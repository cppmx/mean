# El backend

El código es muy sencillo, está formado por dos archivos. El primero de ellos se llama `dbHandler.js` el cual contiene lo siguiente:

```javascript
const MongoClient = require('mongodb').MongoClient;


/** Conectarse a una colección de MongoDB
*
* @param {String} dbString - Cadena de conexión de MongoDB
* @param {String} dbName - Nombre de la base de datos
* @param {String} dbTable - Nombre de la tabla o colección
* @returns Dos variables: el cliente y la colección.
*/
async function connectToCollection(dbString, dbName, dbTable) {
   const client = new MongoClient(dbString);
   await client.connect();


   const database = client.db(dbName);
   const collection = database.collection(dbTable);


   return { client, collection };
}


module.exports = connectToCollection;
```

El método `connectToCollection` es muy simple, recibe la cadena de conexión hacia la BD, el nombre de la base de datos, y el nombre de la tabla. Con esos datos se conecta a la instancia de MongoDB, y devuelve el cliente de MongoDB y la colección. Aquí no se valida si se logró establecer o no una conexión, de eso se encargarán los métodos que consuman esta función.

El segundo archivo se llama `server.js`, y en él se definen los endpoints que ofrecerá el backend. Los endpoints que se exponen son los siguientes:

## Un endpoint para probar la conexión a la BD

```javascript
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
```

Como se puede observar en el código anterior, este método expone el path `/aapi/testdb` mediante el verbo GET. Dentro de un bloque `try...catch` se intenta hacer la conexión a la base de datos. Si todo sale bien este devolverá un código 200 y un JSON con información de que se ha conseguido establecer comunicación con la base de datos. En caso contrario devolverá un código 503 para notificar que ha habido un error interno.

## Un endpoint para ver la cadena de conexión

```javascript
const dbString = process.env.CONN_STR;


app.get('/api/dbstring', (req, res) => {
   if (typeof dbString === 'string' && dbString.length > 0) {
       res.status(200).json({ data: dbString });
   } else {
       res.status(503).json({message: "¡No se ha definido una cadena de conexión!"})
   }
});
```

El servicio de backend va a tener la cadena de conexión en una variable de ambiente llamada `CONN_STR`. Desde el path `/api/dbstring` con el verbo GET podremos obtener esa cadena de conexión, si no está definida, entonces se devolverá un error 503.

## Un endpoint para insertar items a la base de datos

```javascript
app.post('/api/add', async (req, res) => {
   try {
       const { client, collection } = await connectToCollection(dbString, dbName, dbTable);


       // Insertar el documento desde los datos de la solicitud
       const result = await collection.insertOne(req.body);


       await client.close();


       res.status(200).json({ message: 'Inserción exitosa a la base de datos', data: result });
   } catch (error) {
       res.status(400).json({ message: 'No se modificó la BD!' });
   }
});
```

Usando el apth `/api/add` con un verbo POST se podrá agregar items a la base de datos Mongo. Si la inserción de los datos es exitosa, entonces se devolverá el siguiente mensaje en formato JSON con un código 200:

```json
{
   "message": "Inserción exitosa a la base de datos",
   "data" {
       "_id": "el ID del item recién insertado",
       "text": "la cadena de texto que fue insertada",
       "date": "la fecha y hora en que se produjo la solicitud de inserción"
   }
}
```

En caso de que exista algún problema con la inserción de los dats, entonces se devolverá el siguiente JSON con un código de error 400:

```json
{
   "error": "No se modificó la BD!"
}
```

## Un endpoint para eliminar items a la base de datos

```javascript
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
```

Se podrá eliminar items de la base de datos al llamar el path `/api/del/_id`, donde `_id` es el identificador del elemento que se desea eliminar. Si la eliminación del item es exitosa, entonces devolverá el siguiente JSON con código 200:

```json
{
   "message": "Eliminación exitosa de un item de la base de datos",
   "data": {
       "_id": null,
       "text": "la cadena de texto que fue eliminada",
       "date": "la fecha y hora en que se produjo la solicitud de eliminación"
   }
}
```

En caso de que exista algún problema con la inserción de los datos, entonces se devolverá el siguiente JSON con un código de error 400:

```json
{
   "error": "No se modificó la BD!"
}
```

## Un endpoint para obtener todos los items de la base de datos

```javascript
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
```

Para obtener todos los items almacenados en la base de datos se usará el path `/api/get` con el verbo GET. En caso de que se obtengan los datos de forma correcta de la base de datos, este path nos devolverá el siguiente JSON con el código 200:

```json
{
   "message": "Conexión exitosa a la base de datos",
   "data": [
       {
           "_id": "id del primer item",
           "text": "la cadena de texto del primer item",
           "date": "la fecha y hora en que se produjo la solicitud de inserción del primer item"
       },
       {
           "_id": "id del segundo item",
           "text": "la cadena de texto del segundo item",
           "date": "la fecha y hora en que se produjo la solicitud de inserción del segundo item"
       },
       ...
   ]
}
```

En caso de que exista algún problema con la obtención de datos, entonces se devolverá el siguiente JSON con un código de error 204:

```json
{
   "error": "¡No hay datos que cargar!"
}
