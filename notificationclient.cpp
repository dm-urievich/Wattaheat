/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAndroidExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "notificationclient.h"

#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidJniEnvironment>
#include <QDebug>
#include <math.h>

#include <QStandardPaths>
#include <QFile>

#include "levmarq.h"

LMstat lmstat;

#define N_MEASUREMENTS 395
#define N_PARAMS 3

double t_data[N_MEASUREMENTS] = { 21.6,  22. ,  22.4,  22.4,  22.5,  22.4,  22.2,  22.3,  22.4,\
                                  22.1,  21.8,  21.6,  22.1,  22. ,  21.7,  21.7,  21.5,  21.5,\
                                  21.4,  21.6,  21.7,  21.8,  21.9,  22. ,  21.9,  22.2,  22.3,\
                                  22.3,  22.4,  22.4,  22.4,  23. ,  23.6,  24.6,  24.3,  24.3,\
                                  24.2,  25. ,  25. ,  25.2,  25.4,  26. ,  26.3,  26.3,  26. ,\
                                  26.1,  25.9,  25.7,  26.1,  26. ,  26.3,  26.4,  26.4,  26.4,\
                                  26.5,  26.8,  26.8,  26.9,  27.2,  27.8,  27.9,  28.2,  28.1,\
                                  28.1,  28. ,  28. ,  28.3,  28.4,  28.8,  29.7,  30. ,  30.1,\
                                  29.8,  30.4,  30.9,  30.6,  30.7,  30.6,  30.3,  30.4,  30.8,\
                                  31.3,  31.3,  31.4,  31.2,  31.4,  31.5,  31.6,  31.8,  32.3,\
                                  32.2,  32.7,  32.4,  32.3,  32.7,  33. ,  33. ,  33.1,  33.2,\
                                  33.3,  33.6,  34. ,  33.9,  34.1,  34.2,  34.4,  34.7,  35.1,\
                                  35.2,  34.9,  35.2,  35.3,  35.1,  35.3,  36. ,  35.9,  35.9,\
                                  36.4,  36.9,  36.5,  36.4,  36.9,  36.9,  36.9,  37.4,  37. ,\
                                  36.9,  36.4,  37. ,  37.1,  37. ,  37.1,  37.1,  37.6,  37.8,\
                                  38. ,  38.7,  39. ,  39.2,  39.5,  40.1,  40.4,  40.6,  40.2,\
                                  40.1,  40.3,  40.4,  40.7,  40.9,  40.5,  40.7,  41.5,  41.4,\
                                  41.3,  40.7,  40.5,  40.8,  41.2,  41.2,  41. ,  41.3,  41.5,\
                                  41.7,  42.1,  42.1,  42.3,  42.2,  41.8,  42. ,  42.4,  42.6,\
                                  42.6,  42.3,  42.4,  42.7,  43.1,  42.9,  42.8,  42.8,  43.1,\
                                  43.4,  44. ,  43.9,  43.9,  43.8,  43.9,  44.4,  44.6,  45.1,\
                                  45.2,  45.2,  45.2,  45.4,  45.7,  45.3,  45.1,  45.1,  45.6,\
                                  45.9,  45.9,  45.9,  46. ,  46.2,  46.2,  46.3,  46.6,  46.9,\
                                  46.9,  47.2,  47.6,  47.5,  47.7,  47.6,  47.7,  48. ,  47.8,\
                                  47.9,  48. ,  48.2,  48. ,  48. ,  48.1,  48.6,  48.6,  49.2,\
                                  48.9,  48.8,  49.2,  49.4,  49.2,  49. ,  49.3,  49.8,  50.3,\
                                  50.7,  50.9,  50.8,  50.6,  50.4,  50.7,  50.9,  51. ,  51.4,\
                                  51.4,  51.8,  51.8,  51.6,  52.3,  52.7,  53.3,  53.1,  54. ,\
                                  53.3,  53.3,  53.6,  53.2,  53. ,  53.1,  53.4,  53.5,  53.6,\
                                  53.9,  53.7,  53.9,  53.9,  52.8,  53.1,  53.1,  53.3,  53.4,\
                                  53.6,  54. ,  54.3,  54.2,  54.4,  54.7,  54.6,  56.5,  56.4,\
                                  55.7,  55.8,  55.9,  56.2,  56.2,  56.3,  56.3,  56.5,  56.9,\
                                  57. ,  57.4,  57.9,  58.2,  57.6,  57.5,  57.9,  58.4,  58.9,\
                                  59.1,  58.4,  59. ,  62.4,  57.6,  56.6,  58.6,  59. ,  59. ,\
                                  59. ,  59.3,  59.5,  59. ,  59.4,  59.2,  59.1,  60. ,  59.8,\
                                  60.3,  60.8,  60.5,  60.4,  61.5,  60.7,  60.7,  61. ,  60.9,\
                                  61. ,  61.3,  61.7,  61.5,  61.4,  61.8,  61.9,  62.6,  62.3,\
                                  62.1,  62. ,  62.3,  62.4,  62.4,  61.7,  62.7,  63.2,  62.8,\
                                  62.9,  63. ,  63.6,  63.9,  63.3,  63.7,  63.5,  63.3,  63.9,\
                                  64. ,  63.8,  63.9,  64.5,  64.3,  63.8,  63.5,  64. ,  64.3,\
                                  65.2,  65.7,  65.9,  65.6,  64.7,  65. ,  65.1,  65.8,  66.2,\
                                  66.6,  66.3,  66. ,  65.5,  66.2,  66.4,  66.8,  67.4,  67.3,\
                                  67. ,  66.8,  66.4,  67.3,  66.9,  67.6,  72.1,  66.6,  66.2,\
                                  67.1,  70. ,  68.8,  68.1,  67.8,  67.3,  67.4,  66.2 };

double params[N_PARAMS] = {200, 20, 0.001}; // Initial values of parameters


/* @brief   Function, describes Newton law of heating/cooling
 *
 * @usage   par[0] - temperature of heater,
 *          par[1] - initial temperature of water,
 *          par[2] - heat transmission coefficient
 *
 * @par     input of Newton Law:
 * @x       samplenumber
 * @fdata   additional data, not used
 *
 * @return  temperature at the time x
 */
double NotificationClient::newton_func(double *par, int x, void *fdata)
{
    Q_UNUSED(fdata)
    return par[0] + (par[1] - par[0]) * exp( -par[2]*x);
}

/*
 * @brief   Gradient function for Newton law of heating
 */
void NotificationClient::gradient(double *g, double *par, int x, void *fdata)
{
    Q_UNUSED(fdata)
    g[0] = 1.0 + exp(-par[2] * x);
    g[1] = exp(-par[2] * x);
    g[2] = -x * (par[1] - par[0]) * exp(-par[2] * x);
}

/*
 * @brief  Function for prediction of time, when target temperature will be reached
 *
 * @par    Parameters from Newton equation
 * @temp   Target temperature
 * @return Number of sample
 */
int NotificationClient::temp_to_time(double *par, double temp)
{
    return -(1/par[2]) * log((temp - par[0])/(par[1] - par[0]));
}


void NotificationClient::logFile(QString data)
{
    QString folder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    folder += "/teamCookLogData.txt";

    qWarning("folder=%s",qPrintable(folder));

    QFile file(folder);

    file.open(QIODevice::Append);
    QTextStream out(&file);
    out << data << "\n";
    file.close();
}

double NotificationClient::prediction(QList<double> data, double targetTemp)
{
    double t_data[data.size()];
    for (int i = 0; i < data.size(); i++) {
        t_data[i] = data[i];
    }

    levmarq_init(&lmstat);
    levmarq(N_PARAMS, params, data.size(), t_data, NULL, &newton_func, &gradient, NULL, &lmstat);

    if (params[0] > 1000 || params[0] < 100) {
        return 9999;
    }

    if (params[1] > 100 || params[1] < 0) {
        return 9999;
    }

    if (params[2] > 1 || params[2] < 0) {
        return 9999;
    }

    return temp_to_time(params, targetTemp);
}

double NotificationClient::model(double time)
{
    return newton_func(params, time, nullptr);
}

QString NotificationClient::testData(QString pp)
{
    int n_iterations;
    levmarq_init(&lmstat);
    n_iterations = levmarq(N_PARAMS, params, N_MEASUREMENTS, t_data, NULL,
            &newton_func, &gradient, NULL, &lmstat);
    qDebug() << "**************** End of calculation ***********************\n";
    qDebug() << "N iterations: %d\n" << n_iterations;
    qDebug() << "T_heater: " << params[0] << " T_0: " << params[1] << " k: " << params[2] << "\n";
    qDebug() << "**************** Interpolation test ***********************\n";
    qDebug() << "Search for temp 70 degrees\n";
    qDebug() << "Result: " <<  temp_to_time(params, 50.0) << " sample\n";

    return "aabb";
}

NotificationClient::NotificationClient(QObject *parent)
    : QObject(parent)
{
    connect(this, SIGNAL(notificationChanged()), this, SLOT(updateAndroidNotification()));
}

void NotificationClient::setNotification(const QString &notification)
{
    m_notification = notification;
    emit notificationChanged();
}

QString NotificationClient::notification() const
{
    return m_notification;
}

QString NotificationClient::getLogFile()
{
    return "";
}

void NotificationClient::updateAndroidNotification()
{
    QAndroidJniObject javaNotification = QAndroidJniObject::fromString(m_notification);
    QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/TeamCook",
                                       "notify",
                                       "(Ljava/lang/String;)V",
                                       javaNotification.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
        // Handle exception here.
        qDebug() << "EXCEPTION!!!";

        env->ExceptionClear();
    }
}
