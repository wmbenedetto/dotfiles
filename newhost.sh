#!/bin/bash
DOMAIN=$1
VERSION=$3

# Check for required args
if [ -z "$1" ]
then
	echo "newhost.sh domain [subdomain] [version]"
	exit
fi

# Default subdomain to www if not specified
if [ -z "$2" ]
then
 	SUBDOMAIN="www"
else
	SUBDOMAIN=$2
fi

# Check whether domain already exists
if [ -f "/etc/apache2/sites-available/$SUBDOMAIN.$DOMAIN" ]
then
	echo "$SUBDOMAIN.$DOMAIN already exists"
	exit
fi

echo "CREATING NEW HOST: $SUBDOMAIN.$DOMAIN ..."

# Duplicate vhost config and replace domain/subdomain with new domain/subdomain
echo "- Creating new vhost for $SUBDOMAIN.$DOMAIN"
sudo cp /etc/apache2/sites-available/www.wmbenedetto.com /etc/apache2/sites-available/$SUBDOMAIN.$DOMAIN
echo "- Replacing $SUBDOMAIN.$DOMAIN in vhost config"
sudo sed -i "s/www.wmbenedetto.com/$SUBDOMAIN.$DOMAIN/g" /etc/apache2/sites-available/$SUBDOMAIN.$DOMAIN
echo "- Replacing $DOMAIN in vhost config"
sudo sed -i "s/wmbenedetto.com/$DOMAIN/g" /etc/apache2/sites-available/$SUBDOMAIN.$DOMAIN

# Set SITEDIR based on whether version is specified
if [ -z "$VERSION" ]
then
	SITEDIR="$HOME/www/sites/$SUBDOMAIN.$DOMAIN"
else
	SITEDIR="$HOME/www/sites/$SUBDOMAIN.$DOMAIN/$VERSION"
fi

# If SITEDIR doesn't exist, create and chown it
if [ ! -d "$SITEDIR" ]
then
	echo "- Creating $SITEDIR"
	mkdir -m 775 "$SITEDIR"
	sudo chown -Rv $USER:www-data "$SITEDIR"
fi

# Symlink host to SITEDIR
echo "- Symlinking $SITEDIR"
ln -s "$SITEDIR" "$HOME/www/hosts/$SUBDOMAIN.$DOMAIN"

# Enable site and restart Apache
sudo a2ensite $SUBDOMAIN.$DOMAIN
sudo /etc/init.d/apache2 reload

echo "DONE!"