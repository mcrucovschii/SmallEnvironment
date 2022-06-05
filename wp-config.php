<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'ak^SMg4g9p5' );

/** Database hostname */
define( 'DB_HOST', '34.220.158.42' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'z4EY7OG bE&+iD!Vl~6+aXFZ,r3YKiStpt8iR3$-Xv`]l&Tp%1J{tXDU-UA{]ag+' );
define( 'SECURE_AUTH_KEY',  'gc>m>$zi|$HAo+^wi yh3~Y9YVmhOW&]rdG@)wyok-?P{=93Q8_@5q~%vK~l`fD1' );
define( 'LOGGED_IN_KEY',    '^w7c`#r`Wb#+Q8u?uG^/<a^~|sm;n};aFMcwl8XW41j$:`c+.% H@VB7QE~zd8x-' );
define( 'NONCE_KEY',        '8az4b$p5u,7t|U9fh[Nh7_Ait=slQtpyjb>,*NXmC_s AZ[WY6E_z~xx+k~X*62y' );
define( 'AUTH_SALT',        'xTUVT2%v}KRRx9Y$}SiAVza)C09MdSkV`:Q%$0_,?nd&tnB<KGtd<&;7IIn9cksN' );
define( 'SECURE_AUTH_SALT', 'h<k> Eth3:p{*e(xkdO|ZedmMn)vv{=y7+<O]N_(0]NGK4Oq%|@geboojb{HU^5P' );
define( 'LOGGED_IN_SALT',   '{+Y<O?)2jXJL3uM%_yvEUxSZwu?JD%>nK~LpLJ6B.:K.&?i&7ezyJZo-FaB;nig-' );
define( 'NONCE_SALT',       'Nn#]-WTw1TlmM@L4xNA:Xt;f1dBOyL&7]`GY>f!R%|vr|{4544D>9t%#p-M3hKD<' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
