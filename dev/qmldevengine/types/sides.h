#ifndef SIDES_H
#define SIDES_H

#include <QJSEngine>
#include <QObject>
#include <QQmlEngine>

class Sides : public QObject
{
        Q_OBJECT
        Q_ENUMS(SidesEnum)
    public:
        enum SidesEnum { Top, Right, Bottom, Left };

        explicit Sides(QObject *parent = 0);

        static QObject* singletonProvider(QQmlEngine* engine, QJSEngine* scriptEngine);

    public Q_SLOTS:
        int oppositeSide(int side);
};

#endif // SIDES_H
