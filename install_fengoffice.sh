#!/bin/bash

EXITO() {
printf "\033[1;32m${1}\033[0m\n"
}

#VARIABLES
DIR_APACHE=/var/www
REPOSITORIO='http://sourceforge.net/projects/opengoo/files/fengoffice'
MYSQL=`which mysql`

EXITO "Iniciando instalación de paquetes necesarios. Ingrese contraseña del Super Usuario"
#su -c "aptitude install apache2 php5 php5-gd php5-mysql mysql-server; a2enmod php5; invoke-rc.d apache2 restart"

echo "Introduzca el directorio de apache donde se encuentre el Feng Office que desee actualizar. Ejemplo1: fengoffice. Ejemplo2: fo_prueba."
read DIR_FENG

EXITO "A continuación se crearán la bd y el usuario que utilizará Feng Office"
echo "Por favor, ingrese el usuario de la base de datos"
read USERDB

echo "Por favor, ingrese el nombre de la base de datos"
read NAMEDB

echo "Por favor, ingrese la contraseña de la base de datos"
read PASSDB

Q0="CREATE USER '$USERDB'@'localhost' IDENTIFIED BY '$PASSDB';"
Q1="CREATE DATABASE IF NOT EXISTS $NAMEDB;"
Q2="GRANT ALL ON $NAMEDB.* TO '$USERDB'@'localhost' IDENTIFIED BY '$PASSDB';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q0}${Q1}${Q2}${Q3}"

EXITO "Por favor, introduzca la contraseña root de mysql"
$MYSQL -uroot -p -e "$Q0"
EXITO "Por favor, introduzca la contraseña root de mysql"
$MYSQL -uroot -p -e "$SQL"

echo "Introduzca la versión a la que quiere instalar. La última probada en este escript fue la 2.7.1.1"
read VERSION
EXITO "Ha introducido la version $VERSION"
sleep 1

mkdir -p /tmp/$DIR_FENG/
cd /tmp/$DIR_FENG/

EXITO "Descargando la versión $VERSION"
wget -c $REPOSITORIO/fengoffice_$VERSION/fengoffice_$VERSION.zip

unzip fengoffice_$VERSION.zip
rm fengoffice_$VERSION.zip
cp -rv /tmp/$DIR_FENG $DIR_APACHE

EXITO "Otorgando permisos a cache/ config/ tmp/ upload/"
sleep 1
chmod -R 777 $DIR_APACHE/$DIR_FENG/cache/
chmod -R 777 $DIR_APACHE/$DIR_FENG/config/
chmod -R 777 $DIR_APACHE/$DIR_FENG/tmp/
chmod -R 777 $DIR_APACHE/$DIR_FENG/upload/
EXITO "Instalación culminada. Por favor, ingrese a http://localhost/fengoffice/ para continuar la instalación vía web."
