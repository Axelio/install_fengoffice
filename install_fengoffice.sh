#!/bin/bash

EXITO() {
printf "\033[1;32m${1}\033[0m\n"
}

#VARIABLES
DIR_APACHE='/var/www'
REPOSITORIO='http://sourceforge.net/projects/opengoo/files/fengoffice'
MYSQL=`which mysql`

EXITO "Iniciando instalación de paquetes necesarios. Ingrese contraseña del Super Usuario"
su -c "aptitude install apache2 php5 php5-gd php5-mysql mysql-server; a2enmod php5; invoke-rc.d apache2 restart"

EXITO "A continuación se crearán la bd y el usuario que utilizará Feng Office"
echo "Por favor, ingrese el usuario de la base de datos"
read USERDB

echo "Por favor, ingrese el nombre de la base de datos"
read DB

echo "Por favor, ingrese la contraseña de la base de datos"
read PASSDB

Q0="CREATE USER '$USERDB'@'localhost' IDENTIFIED BY '$PASSDB';"
Q1="CREATE DATABASE IF NOT EXISTS $DB;"
Q2="GRANT ALL ON $DB.* TO '$USERDB'@'localhost' IDENTIFIED BY '$PASSDB';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q0}${Q1}${Q2}${Q3}"

EXITO "Por favor, introduzca la contraseña root de mysql"
MYSQL -uroot -p -e "$SQL"

echo "Introduzca la versión a la que quiere instalar. La última probada en este escript fue la 2.7.1.1"
read VERSION
EXITO "Ha introducido la version $VERSION"
sleep 1

mkdir -p /tmp/fengoffice/
cd /tmp/fengoffice/

EXITO "Descargando la versión $VERSION"
wget -c $REPOSITORIO/fengoffice_$VERSION/fengoffice_$VERSION.zip

unzip fengoffice_$VERSION.zip
rm fengoffice_$VERSION.zip
rsync -azvhP /tmp/fengoffice $DIR_APACHE
cd $DIR_APACHE/fengoffice

EXITO "Otorgando permisos a cache/ config/ tmp/ upload/"
sleep 1
cd $DIR_APACHE/fengoffice/
chmod -R o+w cache/ config/ tmp/ upload/
EXITO "Instalación culminada. Por favor, ingrese a http://localhost/fengoffice/ para continuar la instalación vía web."
