#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QFileDialog>

///////////////////////////////////////////////////////////////////////////////
namespace baadraan {
///////////////////////////////////////////////////////////////////////////////
class CustomFileDialog:public QFileDialog{
public:
    CustomFileDialog();
};


class FileManager : public QObject
{
    Q_OBJECT
public:
    FileManager();
    Q_INVOKABLE bool readFiles(const QStringList& filesPathList);
    Q_INVOKABLE bool writeToFile(const QString& path, const QString data);
    Q_INVOKABLE QString formatDescription(const QString& des);
    Q_INVOKABLE QString openSaveDialog(QString name);
    Q_INVOKABLE QString getOpenedFilePath();
    void setOpenedFilePaht(const QString& filepath);

signals:
    void newElement(QString acNumber, double money);
    void readError(QStringList readErrors);

private:
    QString m_description;
    QString m_openFilePath = "";
    CustomFileDialog m_saveFileDialog;
};
///////////////////////////////////////////////////////////////////////////////
} // namespace baadraan
///////////////////////////////////////////////////////////////////////////////
#endif // FILEMANAGER_H
