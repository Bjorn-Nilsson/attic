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


#ifndef _QSCGI_H_
#define _QSCGI_H_

#include <QHash>

#include <QTcpServer>


class QScgiServer : public QTcpServer {
  Q_OBJECT
public:
  QScgiServer(QObject *parent = 0);
  
signals:
  //  virtual void newRequest(const QHash &parameters);

private slots:
  void handleNewConnection();
  
private:
  void sendMalformedRequestError(QTcpSocket *client, const char *message = "No debug message");
  
  QHash<QString, QString> m_parameters;
  QByteArray m_body;
};

#endif /* _QSCGI_H_ */
