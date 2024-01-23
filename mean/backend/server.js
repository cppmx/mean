const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { MongoClient, ObjectId } = require('mongodb');
const connectToCollection = require('./dbHandler.js');
const dbConfig = require('./config.json');

const app = express();
const port = 3000;
const dbName = "unir";
const dbTable = "actividad"
const dbString = `mongodb://${dbConfig.mongo_host}:${dbConfig.mongo_port}/`;

app.use(bodyParser.json());

// Habilitar CORS solo para desarrollo
if (process.env.NODE_ENV !== 'production') {
    app.use(cors());
}

app.get('/api/testdb', async (req, res) => {
    try {
        // Conectar a la base de datos
        const { client, collection } = await connectToCollection(dbString, dbName, dbTable);
        const result = await collection.findOne({});

        // Cerrar la conexión
        await client.close();

        res.status(200).json({ message: 'Conexión exitosa a la base de datos', data: result });
    } catch (error) {
        console.error('Error al conectar a la base de datos:', error);
        res.status(503).json({ error: 'La BD no está disponible' });
    }
});

app.get('/api/get', async (req, res) => {
    try {
        const { client, collection } = await connectToCollection(dbString, dbName, dbTable);
        const result = await collection.find({}).toArray();

        await client.close();

        res.status(200).json({ message: 'Conexión exitosa a la base de datos', data: result });
    } catch (error) {
        res.status(204).json({ error: 'No hay datos que cargar!' });
    }
});

app.post('/api/add', async (req, res) => {
    try {
        const { client, collection } = await connectToCollection(dbString, dbName, dbTable);

        // Insertar el documento desde los datos de la solicitud
        const result = await collection.insertOne(req.body);

        await client.close();

        res.status(200).json({ message: 'Inserción exitosa a la base de datos', data: result });
    } catch (error) {
        res.status(400).json({ error: 'No se modificó la BD!' });
    }
});

app.delete('/api/del/:_id', async (req, res) => {
    try {
        console.info("Intentando eliminar el item " + req.params._id);
        const { client, collection } = await connectToCollection(dbString, dbName, dbTable);

        // Eliminar documento con el ID proporcionado en los datos de la solicitud
        const result = await collection.deleteOne({ _id: new ObjectId(req.params._id) });

        await client.close();

        res.status(200).json({ message: 'Eliminación exitosa de un item de la base de datos', data: result });
    } catch (error) {
        console.error('Error en la base de datos:', error);
        res.status(400).json({ error: 'No se modificó la BD!' });
    }
});

app.get('/api/dbstring', (req, res) => {
    if (typeof dbString === 'string' && dbString.length > 0) {
        res.status(200).json({ data: dbString });
    } else {
        res.status(503).json({message: "¡No se ha definido una cadena de conexión!"})
    }
});

app.get('/', (req, res) => {
    res.send('Hello MEAN Stack!');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
