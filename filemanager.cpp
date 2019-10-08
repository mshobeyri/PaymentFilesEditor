#include "filemanager.h"

#include <QDebug>
#include <QFile>
#include <QTextEncoder>
#include <QDate>
#include <QLocale>


///////////////////////////////////////////////////////////////////////////////
namespace baadraan {
///////////////////////////////////////////////////////////////////////////////
CustomFileDialog::CustomFileDialog(){
    this->setAcceptMode(QFileDialog::AcceptSave);
}

///////////////////////////////////////////////////////////////////////////////
FileManager::FileManager() {}

bool
FileManager::readFiles(const QStringList& filesPathList) {
    bool isFirstLine = true;
    for (const auto& filePath : filesPathList) {
        isFirstLine = true;
        QFile file(filePath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return false;

        while (!file.atEnd()) {
            QByteArray line = file.readLine();
            if (isFirstLine) {
                isFirstLine = false;
                continue;
            }
            newElement(line.left(10), line.mid(10, 15).toDouble());
        }
    }
    return true;
}

bool
FileManager::writeToFile(const QString& path, const QString data) {
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;
    QTextStream out(&file);
    out.setCodec(QTextCodec::codecForName("Windows-1256"));
    out << data;
    return true;
}

//QString
//FileManager::formatDescription(const QString& des) {
//    QString translated = des;

//    translated.replace("\xDA\xAF","]"); // g
//    translated.replace("\xD9\xBE","["); // p
//    translated.replace("\xDA\x86","="); // ch

//    QTextEncoder* encoder = QTextCodec::codecForName("Windows-1256")->makeEncoder();
//    QTextDecoder* decoder = QTextCodec::codecForName("Windows-1252")->makeDecoder();
//    auto enc = encoder->fromUnicode(translated);

//    auto dec = decoder->toUnicode(enc,des.length());

//    dec.replace("]",QChar('\x90'));  // g
//    dec.replace("[",QChar('\x81'));  // p
//    dec.replace("=",QChar('\x8D')); // ch

//    return dec;
//}

QString
FileManager::formatDescription(const QString& des) {
    return des;
}

QString
FileManager::openSaveDialog(QString name){
    QDate::currentDate();
    return m_saveFileDialog.getSaveFileName(&m_saveFileDialog,
                                            "Save", name,"Payment Files(*.pay)");
}

QString
FileManager::getOpenedFilePath(){
    return m_openFilePath;
}

void
FileManager::setOpenedFilePaht(const QString& filepath){
    m_openFilePath = filepath;
}

///////////////////////////////////////////////////////////////////////////////
} // namespace baadraan
///////////////////////////////////////////////////////////////////////////////
