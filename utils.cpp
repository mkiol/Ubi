#include "utils.h"
#include <QDebug>

Utils::Utils(QmlApplicationViewer *viewer, QSettings *settings, QObject *parent) :
    QObject(parent)
{
    _viewer = viewer;
    _settings = settings;
    _clipboard = QApplication::clipboard();

    _nam = new QNetworkAccessManager(this);
    isFinished = true;
}

void Utils::minimizeWindow()
{
#if defined(Q_WS_MAEMO_5)
    // This is needed for Maemo5 to recognize minimization
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage message = QDBusMessage::createSignal(
                "/","com.nokia.hildon_desktop","exit_app_view");
    connection.send(message);
#else
    _viewer->setWindowState(Qt::WindowMinimized);
#endif
}

void Utils::setOrientation(const QString &orientation)
{
    if(orientation=="auto")
        _viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    if(orientation=="landscape")
        _viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    if(orientation=="portrait")
        _viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
}

bool Utils::isAuthorized()
{
    QString ck = customerKey();
    QString cs = customerSecret();
    QString t = token();
    QString ts = tokenSecret();

    if(ck!="" && cs!="" && t!="" && ts!="")
        return true;
    else
        return false;
}

void Utils::resetAuthorization()
{
    setCustomerKey("");
    setCustomerSecret("");
    setToken("");
    setTokenSecret("");
    setName("");
}

QString Utils::name()
{
    return _settings->value("name").toString();
}

void Utils::setName(const QString &name)
{
    _settings->setValue("name",name);
}

QString Utils::locale()
{
    return _settings->value("locale").toString();
}

void Utils::setLocale(const QString &locale)
{
    _settings->setValue("locale",locale);
}

QString Utils::customerKey()
{
    return _settings->value("customer_key").toString();
}

void Utils::setCustomerKey(const QString &ckey)
{
    _settings->setValue("customer_key",ckey);
}

QString Utils::customerSecret()
{
    return _settings->value("customer_secret").toString();
}

void Utils::setCustomerSecret(const QString &csecret)
{
    _settings->setValue("customer_secret",csecret);
}

QString Utils::token()
{
    return _settings->value("token").toString();
}

void Utils::setToken(const QString &token)
{
    _settings->setValue("token",token);
}

QString Utils::tokenSecret()
{
    return _settings->value("token_secret").toString();
}

/*QString Utils::backgroundColor()
{
    return _settings->value("background_color").toString();
}*/

void Utils::setTokenSecret(const QString &tsecret)
{
    _settings->setValue("token_secret",tsecret);
}

QString Utils::lastFolder()
{
    return _settings->value("last_folder").toString();
}

void Utils::setLastFolder(const QString &folder)
{
    _settings->setValue("last_folder",folder);
}

/*void Utils::setBackgroundColor(const QString &color)
{
    _settings->setValue("background_color",color);
}*/


void Utils::downloadFile(const QString &folder, const QString &filename,
                         const QString &url, int size, const QString &auth)
{
    RequestData data;
    data.isDownload = true;
    data.folder = folder;
    data.filename = filename;
    data.url = url;
    data.auth = auth;
    data.size = size;
    quee.append(data);

    emit downloadAdded(filename);

    if(isFinished){
        start();
    }
}

void Utils::start()
{
    if(quee.isEmpty()) {
        //qDebug() << "quee.isEmpty";
        return;
    }

    RequestData data = quee.takeFirst();

    QUrl url(data.url);
    QNetworkRequest req(url);
    //qDebug() << "Authorization: " << data.auth;
    //qDebug() << "Url: " << url.toEncoded();
    req.setRawHeader("Authorization", data.auth.toAscii());

    if(data.isDownload)
    {
        QNetworkReply* reply = _nam->get(req);

        connect(reply,SIGNAL(finished()),this,SLOT(downloadFinished()));
        connect(reply,SIGNAL(downloadProgress(qint64,qint64)),this,SLOT(downloadProgress(qint64,qint64)));
        connect(reply,SIGNAL(error(QNetworkReply::NetworkError)),this,SLOT(error(QNetworkReply::NetworkError)));

        cur_reply = reply;
        cur_folder = data.folder;
        cur_filename = data.filename;
        cur_size = data.size;

        isFinished = false;

        emit downloadStarted(data.filename);

        //qDebug() << "startDownload, filename: " << cur_filename;
    }
    else
    {
        QString filepath = data.folder + "/" + data.filename;
        //qDebug() << "filapath: " << filepath;
        cur_file = new QFile(filepath);
        if(cur_file->open(QIODevice::ReadOnly)) {
            QNetworkReply* reply = _nam->put(req,cur_file);

            connect(reply,SIGNAL(finished()),this,SLOT(uploadFinished()));
            connect(reply,SIGNAL(uploadProgress(qint64,qint64)),this,SLOT(uploadProgress(qint64,qint64)));
            connect(reply,SIGNAL(error(QNetworkReply::NetworkError)),this,SLOT(error(QNetworkReply::NetworkError)));

            cur_reply = reply;
            cur_folder = data.folder;
            cur_filename = data.filename;
            cur_size = cur_file->size();

            isFinished = false;

            emit uploadStarted(data.filename);

            //qDebug() << "size:" << cur_file->size();

        } else {
            qDebug() << "error: file not open!";
        }

    }
}

void Utils::downloadFinished()
{
    //qDebug() << "downloadFinished";
    isFinished = true;
    if (cur_reply->error() == QNetworkReply::NoError)
    {
        int httpStatus = cur_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        //qDebug() << "status: " << httpStatus;

        if(httpStatus<300) {
            QByteArray bytes = cur_reply->readAll();
            QString filepath = cur_folder + "/" + cur_filename;
            QFile file(filepath);
            file.open(QIODevice::WriteOnly);
            int len = bytes.length();
            QDataStream out(&file);
            out.writeRawData(bytes.constData(),len);
            file.close();
            emit fileDownloaded(cur_filename);
        } else {
            qDebug() << "download error";
            emit downloadError(cur_filename);
        }
    }
    else if (cur_reply->error() == QNetworkReply::OperationCanceledError)
    {
        emit operationCanceled(cur_filename);
    }
    else
    {
        //qDebug() << "download error";
        emit downloadError(cur_filename);
    }

    cur_reply->close();
    cur_reply->deleteLater();

    start();
}

void Utils::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    //qDebug() << "progres: " << 100*bytesReceived/cur_size << "%";

    float progress = (float)bytesReceived/cur_size;

    emit fileDownloadProgress(cur_filename,progress);
}

void Utils::error(QNetworkReply::NetworkError code)
{
    qDebug() << "error: " << code;
}

void Utils::uploadFile(const QString &folder, const QString &filename,
                       const QString &url, const QString &auth)
{
    //qDebug() << "uploadFile";

    RequestData data;
    data.isDownload = false;
    data.folder = folder;
    data.filename = filename;
    data.url = url;
    data.auth = auth;
    quee.append(data);

    emit uploadAdded(filename);

    //qDebug() << "utils.cpp:uploadFile url=" << url;

    if(isFinished){
        start();
    }
}

void Utils::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    //qDebug() << "progres: " << 100*bytesSent/cur_size << "%";
    //qDebug() << "progres: " << 100*bytesSent/bytesTotal << "%";

    float progress = (float)bytesSent/cur_size;
    emit fileUploadProgress(cur_filename,progress);
}

void Utils::uploadFinished()
{
    //qDebug() << "uploadFinished";
    isFinished = true;
    if (cur_reply->error() == QNetworkReply::NoError)
    {
        emit fileUploaded(cur_filename);
    }
    else if (cur_reply->error() == QNetworkReply::OperationCanceledError)
    {
        emit operationCanceled(cur_filename);
    }
    else
    {
        int httpStatus = cur_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        //QString httpStatusMessage = cur_reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
        //QByteArray bytes = cur_reply->readAll();
        //qDebug() << "status: " << httpStatus << " " << httpStatusMessage;
        //qDebug() << "bytes: " << bytes;

        if(httpStatus==503)
        {
            emit fileUploaded(cur_filename);
        } else {
            //qDebug() << "upload error: " << httpStatus << " " << cur_reply->error() << " " << cur_reply->errorString();
            emit uploadError(cur_filename);
        }
    }

    cur_file->close();
    delete cur_file;
    cur_reply->close();
    cur_reply->deleteLater();

    start();
}

bool Utils::emptyQuee()
{
    return isFinished && quee.length()==0;
}

void Utils::test()
{
    QMessageBox msgBox;
    msgBox.setText("Test!");
    msgBox.exec();
}

void Utils::deleteFile(const QString &url, const QString &auth)
{
    //qDebug() << "Utils::deleteFile";

    QUrl _url(url);
    QNetworkRequest req(_url);

    /*qDebug() << "url1=" << url;
    qDebug() << "url2=" << req.url().toString();
    qDebug() << "url3=" << req.url().path();*/

    //qDebug() << "auth: " << auth;
    req.setRawHeader("Authorization", auth.toAscii());

    //qDebug() << "utils.cpp:uploadFile _nam=" << _nam->;

    /*QList<QByteArray> l = req.rawHeaderList();
    QList<QByteArray>::iterator i;
    for(i=l.begin(); i!=l.end(); ++i)
        qDebug() << "header=" << *i;
        */

    temp_reply = _nam->deleteResource(req);
    connect(temp_reply,SIGNAL(finished()),this,SLOT(deleteFinished()));
    connect(temp_reply,SIGNAL(error(QNetworkReply::NetworkError)),this,SLOT(error(QNetworkReply::NetworkError)));
}

void Utils::deleteFinished()
{
    //qDebug() << "Utils::deleteFinished";

    int httpStatus = temp_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QString httpStatusMessage = temp_reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
    QByteArray bytes = temp_reply->readAll();

    //qDebug() << "status: " << httpStatus << " " << httpStatusMessage;
    //qDebug() << "bytes: " << bytes;

    if (temp_reply->error() == QNetworkReply::NoError)
    {
        emit fileDeleted();
    }
    else
    {
        emit operationError(httpStatus);
    }

    temp_reply->close();
    temp_reply->deleteLater();
}

void Utils::setClipboardText(const QString &text)
{
    _clipboard->setText(text, QClipboard::Clipboard);
    _clipboard->setText(text, QClipboard::Selection);
}

bool  Utils::isMaemo()
{
#if defined(Q_WS_MAEMO_5)
    return true;
#endif
    return false;
}

void Utils::cancelFile(const QString & filename)
{
    //qDebug() << "Utils::cancelFile";
    if(!isFinished && cur_filename==filename)
    {
        cur_reply->abort();
    }
    else
    {
        int l = quee.size();
        for(int i=0;i<l;++i) {
            RequestData data = quee.at(i);
            //qDebug() << data.filename;
            if(data.filename==filename) {
                quee.removeAt(i);
                emit fileRemovedFromQuee(filename);
                return;
            }
        }
    }
}
