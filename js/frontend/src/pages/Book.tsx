//import {FC, ReactElement, useContext, useEffect, useState} from "react";
import type {FC, ReactElement} from "react";
import {useContext, useEffect, useState} from "react";
//import {Helmet} from "react-helmet";
import {AppContext} from "../App";
import type {Product} from "../model/Product";
import {useParams} from "react-router-dom";
import {getJsonApi} from "../utils/network";
import {Grid} from "@mui/material";
import {styles} from "../utils/styles";
import {convertToObject} from "../utils/parsing";
import {sanitizeUrl} from "../utils/urlsafety";

const Book: FC<{}> = (): ReactElement => {

    const classes = styles();

    const context = useContext(AppContext);

    const { bookId } = useParams();

    context.setAllBookId(bookId || "");

    const [book, setBook] = useState<Product | null>(null);

    useEffect(() => {
        if (context.settings.mockBackend) {
            fetch('mock/product-' + bookId + '.json')
                .then(response => response.json())
                .then(data => setBook(convertToObject<Product>(data)));
            return;
        }

        getJsonApi<Product>(context.settings.productEndpoint + "/" + bookId, context.partition)
            .then(data => setBook(convertToObject(data)))
    }, [bookId, setBook, context.settings.productEndpoint, context.partition, context.settings.mockBackend]);

    return (
        <>
            
                <title>
                    {context.settings.title}
                </title>
            
            {!book && <div>Loading...</div>}
            {book && <Grid container={true} className={classes.content}>
                <Grid size={{ md: 4, sm: 12 }}>
                    <img id="coverimage"
                         className={classes.image}
                         src={sanitizeUrl(book.data.attributes.image) || "https://via.placeholder.com/300x400"}
                         alt={book.data.attributes.name || ""}/>
                </Grid>
                <Grid size={{ md: 8, sm: 12 }}>
                    <h1>{book.data.attributes.name}</h1>
                    <p>{book.data.attributes.description}</p>
                    <h2>Downloads</h2>
                    <ul>
                        {sanitizeUrl(book.data.attributes.pdf) && <li><a href={sanitizeUrl(book.data.attributes.pdf)} rel="noopener noreferrer">PDF</a></li>}
                        {sanitizeUrl(book.data.attributes.epub) && <li><a href={sanitizeUrl(book.data.attributes.epub)} rel="noopener noreferrer">EPUB</a></li>}
                        {sanitizeUrl(book.data.attributes.web) && <li><a href={sanitizeUrl(book.data.attributes.web)} rel="noopener noreferrer">Link</a></li>}
                    </ul>
                </Grid>
            </Grid>}

        </>
    );
}

export default Book;