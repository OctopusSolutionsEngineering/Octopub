import {FC, ReactElement, useContext, useState} from "react";
import {Helmet} from "react-helmet";
import {Button, FormLabel, Grid, TextField} from "@mui/material";
import {AppContext} from "../../App";
import {styles} from "../../utils/styles";
import {useNavigate} from "react-router-dom";

const Settings: FC = (): ReactElement => {

    const context = useContext(AppContext);

    const classes = styles();
    const history = useNavigate();
    const [partition, setPartition] = useState<string | null>(context.partition);

    return (
        <>
            <Helmet>
                <title>
                    {context.settings.title}
                </title>
            </Helmet>
            <Grid container={true} className={classes.container}>
                <Grid className={classes.cell} size={{ xs: 12, sm: 12, md: 2 }}>
                    <FormLabel className={classes.label}>Data Partition</FormLabel>
                </Grid>
                <Grid className={classes.cell} size={{ xs: 12, sm: 12, md: 10 }}>
                    <TextField id="partition" fullWidth={true} variant="outlined" value={partition}
                               onChange={v => {
                                   setPartition(v.target.value);

                               }}/>
                    <span className={classes.helpText}>
                        <p>
                            The data partition defines what resources the web app has access to. All resources under the
                            default partition of "main" can be read, only resources in the current partition
                            can be edited or deleted, and new resources will be placed into the current partition.
                        </p>
                        <p>
                            Set the data partition to "main" to work in default partition.
                        </p>
                    </span>
                </Grid>
                <Grid container={true} className={classes.cell} size={{ xs: 12, sm: 12, md: 2 }}>

                </Grid>
                <Grid container={true} className={classes.cell} size={{ xs: 12, sm: 12, md: 10 }}>
                    <Button variant={"outlined"} onClick={_ => saveSettings()}>Save Settings</Button>
                </Grid>
            </Grid>
        </>
    );

    function saveSettings() {
        const fixedPartition = partition ? partition.trim() : "";
        localStorage.setItem("partition", fixedPartition);
        context.setPartition(fixedPartition);
        history('/');
    }
}


export default Settings;