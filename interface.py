# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'interface.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!
import os, time
import tempfile

from PyQt5 import QtCore, QtWidgets
from PyQt5.QtWidgets import QFileDialog, QWidget
import subprocess


class Ui_INSAT(QWidget):
    def setupUi(self, INSAT):
        INSAT.setObjectName("INSAT")
        INSAT.resize(579, 600)
        self.centralwidget = QtWidgets.QWidget(INSAT)
        self.centralwidget.setObjectName("centralwidget")
        self.txtCode = QtWidgets.QTextEdit(self.centralwidget)
        self.txtCode.setGeometry(QtCore.QRect(40, 30, 511, 231))
        self.txtCode.setObjectName("txtCode")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(40, 10, 71, 16))
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(50, 280, 47, 13))
        self.label_2.setObjectName("label_2")
        self.txtOutput = QtWidgets.QTextEdit(self.centralwidget)
        self.txtOutput.setGeometry(QtCore.QRect(40, 310, 511, 231))
        self.txtOutput.setObjectName("txtOutput")
        INSAT.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(INSAT)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 579, 21))
        self.menubar.setObjectName("menubar")
        self.menuFichier = QtWidgets.QMenu(self.menubar)
        self.menuFichier.setObjectName("menuFichier")
        self.menuExecution = QtWidgets.QMenu(self.menubar)
        self.menuExecution.setObjectName("menuExecution")
        INSAT.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(INSAT)
        self.statusbar.setObjectName("statusbar")
        INSAT.setStatusBar(self.statusbar)
        self.btnNew = QtWidgets.QAction(INSAT)
        self.btnNew.setObjectName("btnNew")
        self.btnOpen = QtWidgets.QAction(INSAT)
        self.btnOpen.setObjectName("btnOpen")
        self.btnCompiler = QtWidgets.QAction(INSAT)
        self.btnCompiler.setObjectName("btnCompiler")
        self.menuFichier.addAction(self.btnNew)
        self.menuFichier.addAction(self.btnOpen)
        self.menuExecution.addAction(self.btnCompiler)
        self.menubar.addAction(self.menuFichier.menuAction())
        self.menubar.addAction(self.menuExecution.menuAction())

        self.retranslateUi(INSAT)
        QtCore.QMetaObject.connectSlotsByName(INSAT)

    def retranslateUi(self, INSAT):
        _translate = QtCore.QCoreApplication.translate
        INSAT.setWindowTitle(_translate("INSAT", "MainWindow"))
        self.label.setText(_translate("INSAT", "Source Code"))
        self.label_2.setText(_translate("INSAT", "Output"))
        self.menuFichier.setTitle(_translate("INSAT", "Fichier"))
        self.menuExecution.setTitle(_translate("INSAT", "Execution"))
        self.btnNew.setText(_translate("INSAT", "New"))
        self.btnOpen.setText(_translate("INSAT", "Open"))
        self.btnCompiler.setText(_translate("INSAT", "Compiler"))
        self.btnOpen.triggered.connect(self.openFile)
        self.btnCompiler.triggered.connect(self.compileFile)
        self.btnNew.triggered.connect(self.new)

    def openFile(self):
        self.txtOutput.clear()
        filename = QFileDialog.getOpenFileName(self, 'open File')
        if filename[0]:
            f = open(filename[0], "r")
            data = f.read()
            self.txtCode.setText(data)
            f.close()

    def compileFile(self):
        with tempfile.NamedTemporaryFile(delete=False, mode='w+t') as fp:
            fp.writelines(self.txtCode.toPlainText())
            fp.seek(0)
            output = os.popen(r'"E:\GL4\sem2\compilation\syntaxique\tp\test.exe"' + " < " + fp.name).read()
            self.txtOutput.setText(output)

    def new(self):
        self.txtCode.clear()
        self.txtOutput.clear()


if __name__ == "__main__":
    import sys

    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_INSAT()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
