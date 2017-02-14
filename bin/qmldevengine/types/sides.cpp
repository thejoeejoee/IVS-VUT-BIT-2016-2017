#include "sides.h"

Sides::Sides(QObject *parent) : QObject(parent) {}

QObject* Sides::singletonProvider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Sides();
}

int Sides::oppositeSide(int side)
{
    const SidesEnum eSide = (SidesEnum)side;

    if(eSide == Sides::Top || eSide == Sides::Right)
        return side + 2;
    return side - 2;
}
