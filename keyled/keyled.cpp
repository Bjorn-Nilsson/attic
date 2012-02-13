/*
 * Copyright (C) 2009 Lorenzo Villani.
 * Released under GPLv2 license.
 */

#include <QApplication>
#include <QFile>
#include <QIcon>
#include <QSystemTrayIcon>
#include <QDebug>
#include <QThread>
#include <QX11Info>

#include <X11/Xlib.h>
#include <X11/XKBlib.h>

#define CAPSLOCK_MASK   0x00000001

class Reader : public QThread {
public:
  Reader(QSystemTrayIcon *tray, QIcon *iconOn, QIcon *iconOff)
    : QThread(0), m_tray(tray), m_iconOn(iconOn), m_iconOff(iconOff) {}

  void run() {
    qDebug() << "Running thread...";

    Display* display = XOpenDisplay(NULL); // Meh

    if (XkbSelectEvents(display, XkbUseCoreKbd, XkbIndicatorStateNotifyMask, XkbIndicatorStateNotifyMask)) {
    // Loop
	while (1) {
	  XkbEvent xkbEvent;
	  XNextEvent(display, &xkbEvent.core);
	  unsigned int state = xkbEvent.indicators.state & CAPSLOCK_MASK;
	  if (state == 0) {
	    qDebug() << "Caps lock is OFF";
	    m_tray->setIcon(*m_iconOff);
	    //write(fd, (int)0, sizeof(int));
	  } else {
	    qDebug() << "Caps lock is ON";
	    m_tray->setIcon(*m_iconOn);
	    //write(fd, (int)1, sizeof(int));
	  }
	}
    }

    XCloseDisplay(display);
  }
private:
  QSystemTrayIcon *m_tray;
  QIcon *m_iconOn;
  QIcon *m_iconOff;
};



int main(int argc, char **argv) {
  QApplication app(argc, argv);

  QIcon iconOn(":/enabled.png");
  QIcon iconOff(":/disabled.png");

  QSystemTrayIcon tray(iconOff);
  tray.setVisible(true);

  Reader reader(&tray, &iconOn, &iconOff);
  reader.start();

  return app.exec();
}

// Local Variables:
// compile-command: "qmake-qt4 && make"
// End:
