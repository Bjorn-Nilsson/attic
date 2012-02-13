#include <QCoreApplication>

#include "qscgi.h"

int main(int argc, char **argv) {
  QCoreApplication app(argc, argv);
  QScgiServer scgiServer;
  scgiServer.listen(QHostAddress::Any, 30333);
  return app.exec();
}
