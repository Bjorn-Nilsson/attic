/*
 * This file is part of QScgi
 *
 * (C) Copyright 2009 by Lorenzo Villani
 *
 * QScgi is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation, version 3 of the
 * License.
 * 
 * QScgi is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with QScgi. If not, see
 * <http://www.gnu.org/licenses/>.
 */

#include "qscgi.h"

#include <QDebug>
#include <QByteArray>

#include <QTcpSocket>
#include <QHttpResponseHeader>


QScgiServer::QScgiServer(QObject *parent) : QTcpServer(parent) {
  connect(this, SIGNAL(newConnection()), this, SLOT(handleNewConnection()));
}


/**
 * The request is divided in two parts:
 * - a header
 * - a body, which comes after the header
 * All headers (request parameters from now on) are encoded
 * as a SINGLE netstring, see the reference for details
 *
 * \see: http://python.ca/scgi/protocol.txt
 */
void QScgiServer::handleNewConnection() {
  qDebug() << "SCGI: Client connected...";
  
  QTcpSocket *client = nextPendingConnection();
  connect(client, SIGNAL(disconnected()), client, SLOT(deleteLater()));
  client->waitForReadyRead();

  QByteArray request(client->readAll());
  qDebug() << "SCGI: Request size:" << request.size();

  // Register the position while we move towards the end of the
  // netstring
  qint32 position = 0;

  // The first field must be the netstring length, if not send back a
  // 400 Bad request and return
  position = request.indexOf(':');
  if (position < 0) {
    sendMalformedRequestError(client, "Couldn't find \":\"");
    return;
  }

  
  // The real length of the netstring inside the raw payload is:
  // netstring reported length + offset (the actual bytes used before
  // the ':' + 1 (remember? index starts from 0)
  bool ok;
  qint32 netstringSize = QString(request.left(position)).toInt(&ok) + position + 1;
  if (!ok) {
    sendMalformedRequestError(client, "Unable to determine netstring size");
    return;
  }
  qDebug() << "SCGI: Header size:" << netstringSize;

  
  // After the ":" the headers begin
  QByteArray key;
  bool evaluatingKey = true;
  while (position < netstringSize) {
    int currentPosition = position + 1;
    
    position = request.indexOf('\0', currentPosition);
    if (position < 0)
      break;
      
    QByteArray segment(request.mid(currentPosition, position - 1));
    if (!segment.isEmpty() && evaluatingKey) {
      key = segment;
      evaluatingKey = false;
    } else if (!segment.isEmpty() && !evaluatingKey) {
      m_parameters[key] = segment;
      evaluatingKey = true;
    }
  }

  
  // Head is right before ','
  m_body = request.mid(netstringSize + 2);
  qDebug() << "SCGI: Body size:" << m_body.size();

  
  // Example code -- drop it when the implementation is ready
  // Write an example response
  QHttpResponseHeader response(200, "OK");
  response.setValue("Content-Type", "text/html");
  client->write(response.toString().toUtf8());

  foreach(const QString& key, m_parameters.keys()) {
    client->write(QString("<li>%1 -> %2</li>\n").arg(key).arg(m_parameters.value(key)).toUtf8());
  }
  
  client->disconnectFromHost();
}

void QScgiServer::sendMalformedRequestError(QTcpSocket *client, const char *message) {
  qDebug() << "SCGI: Got a malformed request from" << client->peerAddress();
  qDebug() << "SCGI:" << message;
  
  QHttpResponseHeader response(400, "Bad Request");
  response.setValue("Content-Type", "text/html");
  client->write(response.toString().toUtf8());
  client->write("<h1>400 Bad Request</h1>");
  
  client->disconnectFromHost();
}
