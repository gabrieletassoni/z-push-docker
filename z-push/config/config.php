<?php
define('BASE_PATH', dirname(__FILE__) . '/');
define('SCRIPT_TIMEOUT', 300);
define('LOGBACKEND_CLASS', 'FileLogBackend');
define('TIMEZONE', 'Europe/Rome');
define('LOGFILEDIR', '/var/log/z-push/');
define('LOGFILE', LOGFILEDIR . 'z-push.log');
define('LOGLEVEL', LOGLEVEL_INFO);
define('STATE_MACHINE', 'FileStateMachine');
define('STATE_DIR', '/var/lib/z-push/');
define('USE_FULLEMAIL_FOR_LOGIN', true);
define('ALLOW_SYNC_OBJECTS', true);
define('SYNC_MAX_ITEMS', 512);
define('SYNC_FILESIZE_MAX', 10485760);
?>
