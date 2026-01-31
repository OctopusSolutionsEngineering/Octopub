import {createContext, useReducer, useState} from "react";
import { ThemeProvider } from '@mui/styles';
//import {responsiveFontSizes, StyledEngineProvider, Theme} from "@mui/material/styles";
import {responsiveFontSizes, StyledEngineProvider} from "@mui/material/styles";
import type {Theme} from "@mui/material/styles";
//import {Helmet} from "react-helmet";
import {darkTheme, lightTheme, createdColouredThemes} from "./theme/appTheme";
import type {RuntimeSettings} from "./config/runtimeConfig";
import Layout from "./components/Layout";
import {HashRouter, Route, Routes} from "react-router-dom";
import Home from "./pages/Home";
import Book from "./pages/Book";
import Settings from "./pages/developer/Settings";
import Branching from "./pages/developer/Branching";
import Health from "./pages/developer/Health";
import {OctopusFeatureProvider} from '@octopusdeploy/openfeature';
import {OpenFeature} from '@openfeature/web-sdk';
import {loadConfig} from "./utils/dynamicConfig";
//import { json } from "node:stream/consumers";
//import * as dotenv from 'dotenv';

//dotenv.config();

declare module '@mui/styles/defaultTheme' {
    // eslint-disable-next-line @typescript-eslint/no-empty-interface
    interface DefaultTheme extends Theme {
    }
}

// define app context
export const AppContext = createContext({
    settings: {} as RuntimeSettings,
    setDeveloperMode: (mode: boolean) => {
    },
    developerMode: false,
    useDefaultTheme: true,
    partition: "",
    setPartition: (mode: string) => {
    },
    allBookId: "",
    setAllBookId: (bookId: string) => {
    }
});

// Register your feature flag provider
//{`${process.env.PUBLIC_URL}/index.html`}

  // Example of what the call would look like.  the darkModeFlagIdentifier is getting the value from an environment variable
  //const provider = new OctopusFeatureProvider ({ clientIdentifier: "eyJhbGciOiJFUzI1NiIsImtpZCI6IjRiZDJlZTY3NDlkMDRhZmE4ZDc1MjlhZDIyODAwM2M4IiwidHlwIjoiSldUIn0.eyJpc3MiOiJodHRwczovL2RlbW8ub2N0b3B1cy5hcHAiLCJzdWIiOiJOemxoWmpSa05HRXRaR00zWmkwME56bGpMV0l3WXpVdE9HSm1NekJqWWpCaE9ESTNPbEJ5YjJwbFkzUnpMVGMwTURFNlJXNTJhWEp2Ym0xbGJuUnpMVFV6T0RRPSJ9.Jvbu0vqgPUmn_UxPwJnBzwgIdvMZuu731M97_Ldd4R6Q-wYz0YdZSwMme6ESwi8BcOf2mARe2gvf_E3dZ1HdMA"});
  let darkModeFlagIdentifier = "undefined";
  let darkModeFlagSlug = "undefined";

  async function getSettings() {
    const settings = await loadConfig();
  
    return settings;
  }

  let jsonSettings = await getSettings();

  darkModeFlagIdentifier =  jsonSettings.clientIdentifier;
  darkModeFlagSlug = jsonSettings.featureToggleSlug;

  //const darkModeFlagIdentifier =  `${process.env.clientIdentifier}`;
  //const darkModeFlagSlug = `${process.env.featureToggleSlug}`;
  
  let darkModeDefault = false;
  
  if (darkModeFlagIdentifier !== "undefined") {

    const provider = new OctopusFeatureProvider ({ clientIdentifier: darkModeFlagIdentifier});
    await OpenFeature.setProviderAndWait(provider);
    //await OpenFeature.setContext({ userid: "bob@octopus.com" });
    const client = OpenFeature.getClient();
    darkModeDefault = client.getBooleanValue(darkModeFlagSlug, false)
    //darkModeDefault = client.getBooleanValue("Dark Mode", false)
    //darkModeDefault = client.getBooleanValue("dark-mode", false) //slug appears to be working
 }
function App(settings: RuntimeSettings) {
    const [useDefaultTheme, toggle] = useReducer(
        (theme) => {
            localStorage.setItem('defaultTheme', String(!theme));
            return !theme;
        },
        localStorage.getItem('defaultTheme') !== "false");

    // In the absence of a theme override, use either the light or dark theme
    //const lightDarkTheme = useDefaultTheme ? lightTheme : darkTheme;
    let lightDarkTheme: Theme;

    //const lightDarkTheme = darkModeDefault ? darkTheme : lightTheme;
    if (darkModeDefault) {
        lightDarkTheme = useDefaultTheme ? darkTheme : lightTheme;
    }
    else {
        lightDarkTheme = useDefaultTheme ? lightTheme : darkTheme;
    }
    const customThemes = createdColouredThemes(settings);
 
    const theme: Theme = responsiveFontSizes(settings.overrideTheme
        ? Object.keys(customThemes)
            .filter((key) => key === settings.overrideTheme)
            .map(key => customThemes[key])
            .pop() ?? lightDarkTheme
        : lightDarkTheme);

 
    const [developerMode, setDeveloperMode] = useState<boolean>(localStorage.getItem("developerMode") === "true");
    const [partition, setPartition] = useState<string>(localStorage.getItem("partition") || "main");
    const [allBookId, setAllBookId] = useState<string>("");

    return <>
        
            <title>{settings.title}</title>
        
        <AppContext.Provider value={{
            settings,
            useDefaultTheme,
            developerMode,
            setDeveloperMode,
            partition,
            setPartition,
            allBookId,
            setAllBookId
        }}>
            <StyledEngineProvider injectFirst>
                <ThemeProvider theme={theme}>
                    <HashRouter>
                        <Routes>
                            <Route element={ <Layout toggleTheme={toggle} enableToggle={!settings.overrideTheme}/>}>
                                <Route path={"/"} element={<Home/>}/>
                                <Route path={"/settings"} element={<Settings/>}/>
                                <Route path={"/book/:bookId"} element={<Book/>}/>
                                <Route path={"/branching"} element={<Branching/>}/>
                                <Route path={"/health"} element={<Health/>}/>
                            </Route>
                        </Routes>
                    </HashRouter>
                </ThemeProvider>
            </StyledEngineProvider>
        </AppContext.Provider>
    </>;
}

export default App;