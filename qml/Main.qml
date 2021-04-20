import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0

import "Storage.js"  as Storage

/* import subfolders */
import "./bloodPressure"
import "./glicemic"
import "./hearth"
import "./weight"
import "./doctorInfo"

/*!
    \brief Aplication MainView
*/
MainView {

    id: root
    objectName: "mainView"

    automaticOrientation: true
    anchorToKeyboard: true

    /* applicationName needs to match the "name" field of the click manifest */
    applicationName: "checkup.fulvio"

    property string appVersion : "1.1.4"

    /* to test themes others then default one */
    //theme.name: "Ubuntu.Components.Themes.SuruDark"

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    width: units.gu(100)
    height: units.gu(75)
    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)
    /* -------------------------------------- */

    //true if horizontal screen
    property bool landscapeWindow: root.width > root.height

    Settings {
       id:settings
       /* to insert or not the default converions entry */
       property bool isFirstUse: true;
       property bool defaultDataImported:false;
       property string appVersion: '1.0.4';
    }

    Component.onCompleted: {

        if(settings.isFirstUse == true){
            /*create the tables and insert default values */
            Storage.initAppFirtsUse();

            //isFirstUse set to false after filling AppConfiguration wizard on first use
        }

        /* for users with old App version */
        else if(settings.isFirstUse == false && settings.appVersion === '1.0.4'){
           console.log("Creating my_doctor table");
           Storage.createMyDoctorTable();
           settings.appVersion = '1.0.5';
        }
    }

    /* ---------- Application config and info pages ---------- */
    Component {
       id: productInfoDialogue
       ProductInfoDialogue{}
    }

    Component {
       id: dataBaseEraserDialog
       DataBaseEraserDialog{}
    }

    Component {
       id: appConfigurationPage
       AppConfigurationPage{}
    }

    Component {
       id: maintenancePage
       MaintenancePage{}
    }

    Component {
       id: applicationHelpPage
       ApplicationHelpPage{}
    }


    //---------- Pages for Phone --------------
    Component {
       id: bloodMainPagePhone
       BloodMainPagePhone{}
    }

    Component {
       id: weightMainPagePhone
       WeightMainPagePhone{}
    }

    Component {
       id: hearthPulsePagePhone
       HearthPulseMainPagePhone{}
    }

    Component {
       id: glicemicMainPagePhone
       GlicemicMainPagePhone{}
    }

    Component {
       id: myDoctorMainPagePhone
       MyDoctorMainPagePhone{}
    }
    //------------------------------------


    //------- Pages for Tablet -----------
    Component {
       id: bloodMainPageTablet
       BloodMainPageTablet{}
    }

    Component {
       id: weightMainPageTablet
       WeightMainPageTablet{}
    }

    Component {
       id: hearthPulsePageTablet
       HearthPulseMainPageTablet{}
    }

    Component {
       id: glicemicMainPageTablet
       GlicemicMainPageTablet{}
    }

    Component {
       id: myDoctorMainPageTablet
       MyDoctorMainPageTablet{}
    }
    //------------------------------------------
    Component {
       id: glicemicHelpPage
       GlicemicHelpPage{}
    }

    Component {
       id: glicemicDiaryPage
       GlicemicDiaryPage{}
    }

    Component {
       id: hearthPulseDiaryPage
       HearthPulseDiaryPage{}
    }

    Component {
       id: weightDiaryPage
       WeightDiaryPage{}
    }

    //-------------------------------------------

    PageStack {
        id: pageStack

        /* set the firts page of the application */
        Component.onCompleted: {

          if(settings.isFirstUse == true){
             pageStack.push(appConfigurationPage);
          }else{
             pageStack.push(mainPage);
          }
        }

        Page {
            id:mainPage
            visible:false

            header: PageHeader {
                title: "Checkup"

                leadingActionBar.actions: [
                    Action {
                        id: aboutPopover
                        /* note: icons names are file names under: /usr/share/icons/suru */
                        iconName: "info"
                        text: i18n.tr("About")
                        onTriggered:{
                            PopupUtils.open(productInfoDialogue)
                        }
                    }
                ]

                /* trailingActionBar is the bar on the right side */
                trailingActionBar.actions: [

                        Action {
                                iconName: "delete"
                                          text: i18n.tr("Delete")
                                          onTriggered:{
                                              PopupUtils.open(dataBaseEraserDialog)
                                          }
                                },

                                Action {
                                        iconName: "settings"
                                        text: i18n.tr("Settings")
                                        onTriggered:{
                                             pageStack.push(appConfigurationPage)
                                        }
                                 },

                                 Action {
                                         iconName: "hud"
                                         text: i18n.tr("Settings")
                                         onTriggered:{
                                              pageStack.push(maintenancePage)
                                         }
                                  },


                                 Action {
                                         iconName: "help"
                                         text: i18n.tr("Help")
                                         onTriggered:{
                                              pageStack.push(applicationHelpPage)
                                        }
                                 }
                     ]
            }


            property int n_columns: height > width ? 2 : 3
            property int n_rows: height > width ? 3 : 2
            property int rectangle_container_size: Math.min (width / n_columns, height / n_rows) * 0.8
            property int rectangle_container_radius: 10
            property int rectangle_container_x_spacing: (width - rectangle_container_size * n_columns) / (n_columns + 1)
            property int rectangle_container_y_spacing: (height - rectangle_container_size * n_rows) / (n_rows + 1)


            Grid {
                x: mainPage.rectangle_container_x_spacing
                y: mainPage.rectangle_container_y_spacing
                columns: mainPage.n_columns
                rows: mainPage.n_rows

                columnSpacing: mainPage.rectangle_container_x_spacing
                rowSpacing: mainPage.rectangle_container_y_spacing

                /* ------ BLOOD PRESSUE ------ */
                Rectangle {
                    id: hearthMenu
                    width: mainPage.rectangle_container_size
                    height: mainPage.rectangle_container_size
                    color: UbuntuColors.red
                    border.color: "black"
                    MouseArea {
                        anchors.fill: parent;
                        Image {
                            id: lengthImage
                            source: Qt.resolvedUrl("bloodPressure/bloodPressure.png")
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: i18n.tr("Blood pressure");
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: lengthImage.bottom
                        }

                        onClicked: {

                            if (root.width > units.gu(110)){
                                pageStack.push(bloodMainPageTablet)
                            }else {
                               pageStack.push(bloodMainPagePhone)
                            }
                        }
                    }
                }

                /* -------- Weight ------ */
                Rectangle {
                    width: mainPage.rectangle_container_size
                    height: mainPage.rectangle_container_size
                    color: UbuntuColors.blue
                    border.color: "black"
                    MouseArea {
                        anchors.fill: parent;

                        Image {
                            id: areaImage
                            source: Qt.resolvedUrl("weight/weight.png")
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: i18n.tr("Weight");
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: areaImage.bottom
                        }

                        onClicked: {
                            if (root.width > units.gu(110)){
                               pageStack.push(weightMainPageTablet)
                            }else {
                               pageStack.push(weightMainPagePhone)
                            }
                        }
                    }
                }

                /* -------- HEARTH PULSE ------ */
                Rectangle {
                    width: mainPage.rectangle_container_size
                    height: mainPage.rectangle_container_size
                    color: UbuntuColors.green
                    border.color: "black"
                    MouseArea {
                        anchors.fill: parent;

                        Image {
                            id: volumeImage
                            source: Qt.resolvedUrl("hearth/hearth.png")
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: i18n.tr("Hearth Pulse");
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: volumeImage.bottom
                        }

                        onClicked: {
                            if (root.width > units.gu(110)){
                                pageStack.push(hearthPulsePageTablet)
                            }else {
                               pageStack.push(hearthPulsePagePhone)
                            }
                        }
                    }
                }

                /* -------- GLICEMIC ------ */
                Rectangle {
                    width: mainPage.rectangle_container_size
                    height: mainPage.rectangle_container_size
                    color: UbuntuColors.porcelain
                    border.color: "black"
                    MouseArea {
                        anchors.fill: parent;

                        Image {
                            id: temperatureImage
                            source: Qt.resolvedUrl("glicemic/glicemic.png")
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: i18n.tr("Glycemic");
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: temperatureImage.bottom
                        }

                        onClicked: {

                            if(root.width > units.gu(110)) {
                               pageStack.push(glicemicMainPageTablet)
                            }else {
                               pageStack.push(glicemicMainPagePhone)
                            }
                        }
                    }
                }



                /* -------- DOCTOR INFO ------ */
                Rectangle {
                    width: mainPage.rectangle_container_size
                    height: mainPage.rectangle_container_size
                    color: UbuntuColors.white
                    border.color: "black"
                    MouseArea {
                        anchors.fill: parent;

                        Image {
                            id: doctroInfoImage
                            source: Qt.resolvedUrl("doctorInfo/doctorInfo.png")
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: i18n.tr("My Doctor");
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: doctroInfoImage.bottom
                        }

                        onClicked: {
                            if (root.width > units.gu(110)){
                                pageStack.push(myDoctorMainPageTablet)
                            }else {
                               pageStack.push(myDoctorMainPagePhone)
                            }
                        }
                    }
                }



            }
        }

    }

 }
