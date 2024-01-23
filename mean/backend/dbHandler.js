const MongoClient = require('mongodb').MongoClient;

/** Conectarse a una colección de MongoDB
 * 
 * @param {String} dbString - Cadena de conexión de MongoDB
 * @param {String} dbName - Nombre de la base de datos
 * @param {String} dbTable - Nombre de la tabla o coleeción
 * @returns Dos varaibles: el cliente y la colección.
 */
async function connectToCollection(dbString, dbName, dbTable) {
    const client = new MongoClient(dbString);
    await client.connect();

    const database = client.db(dbName);
    const collection = database.collection(dbTable);

    return { client, collection };
}

module.exports = connectToCollection;
