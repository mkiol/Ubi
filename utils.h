#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QMap>
#include <QStringList>
#include <QMessageBox>

#if defined(Q_WS_MAEMO_5)
#include <QDBusConnection>
#include <QDBusMessage>
#endif

#include "qmlapplicationviewer.h"

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QmlApplicationViewer *viewer, QSettings *settings, QObject *parent = 0);
    
signals:
    void downloadAdded(QString filename);
    void uploadAdded(QString filename);
    void downloadStarted(QString filename);
    void uploadStarted(QString filename);
    void fileDownloaded(QString filename);
    void fileUploaded(QString filename);
    void downloadError(QString filename);
    void uploadError(QString filename);
    void fileDownloadProgress(QString filename, float progress);
    void fileUploadProgress(QString filename, float progress);

    // U1 api
    void fileDeleted();
    void operationError(int status);
    
public slots:
    void minimizeWindow();
    //QString backgroundColor();
    QString customerKey();
    QString customerSecret();
    QString token();
    QString tokenSecret();
    QString name();
    QString lastFolder();
    QString locale();
    bool emptyQuee();
    void error(QNetworkReply::NetworkError code);
    bool isAuthorized();
    void resetAuthorization();
    //void setBackgroundColor(const QString &);
    void setCustomerKey(const QString &);
    void setCustomerSecret(const QString &);
    void setToken(const QString &);
    void setName(const QString &);
    void setTokenSecret(const QString &);
    void setOrientation(const QString &);
    void setLastFolder(const QString &);
    void setLocale(const QString &);
    void downloadFile(const QString &folder,const QString &filename,
                      const QString &url,int size,const QString &auth);
    void downloadFinished();
    void downloadProgress(qint64,qint64);
    void uploadFile(const QString &folder,const QString &filename,
                    const QString &url,const QString &auth);
    void uploadFinished();
    void uploadProgress(qint64,qint64);

    // U1 api
    void deleteFile(const QString &url,const QString &auth);
    void deleteFinished();
    // ---

    void test();

private:

    struct RequestData {
        bool isDownload;
        QString folder;
        QString filename;
        QString url;
        QString auth;
        qint64 size;
    };

    QmlApplicationViewer *_viewer;
    QSettings *_settings;
    QNetworkAccessManager *_nam;

    QNetworkReply* cur_reply;
    QNetworkReply* temp_reply;

    QString cur_folder;
    QString cur_filename;
    QFile* cur_file;

    qint64 cur_size;
    bool isFinished;

    QList<RequestData> quee;

    QMap<QNetworkReply*,QStringList> downloads;

    void start();
};

#endif // UTILS_H
