import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  private backendUrl = '/api';

  constructor(private http: HttpClient) { }

  testDbConnection(): Observable<any> {
    console.debug("Invocando al backend para que verifique la conexión con la BD ...")
    const url = `${this.backendUrl}/testdb`;
    return this.http.get(url);
  }

  getDBString(): Observable<any> {
    console.debug("Obteniendo el string de conexion de la BD ...");
    const url = `${this.backendUrl}/dbstring`;
    return this.http.get(url);
  }

  dbGetAll(): Observable<any> {
    console.debug("Obteniendo la lista de items desde la BD ...");
    const url = `${this.backendUrl}/get`;
    return this.http.get(url);
  }

  addItem(item: { text: string, date: string }): Observable<any> {
    console.debug("Agregando un item a la BD ...");
    const url = `${this.backendUrl}/add`;
    return this.http.post(url, item);
  }

  deleteItem(itemId: string): Observable<any> {
    console.debug("Eliminando un item de la BD ...");
    const url = `${this.backendUrl}/del/${itemId}`;
    return this.http.delete(url);
  }

}
