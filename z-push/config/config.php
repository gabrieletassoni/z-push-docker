<?php
define('TIMEZONE', 'UTC');
define('BACKEND_PROVIDER', 'BackendIMAP');
define('LOGFILEDIR', '/var/log/z-push/');
define('LOGFILE', LOGFILEDIR . 'z-push.log');
define('LOGLEVEL', LOGLEVEL_INFO);
define('STATE_MACHINE', 'FileStateMachine');
define('STATE_DIR', '/var/lib/z-push/');
define('USE_FULLEMAIL_FOR_LOGIN', true);
define('ALLOW_SYNC_OBJECTS', true);
define('SYNC_MAX_ITEMS', 512);
define('SYNC_FILESIZE_MAX', 10485760);
define('SMTP_SERVER', 'smtp.example.com');
define('SMTP_PORT', 587);
define('SMTP_AUTH', true);
define('SMTP_LOGIN', 'your-smtp-username');
define('SMTP_PASSWORD', 'your-smtp-password');
define('SMTP_SSL', true);
?>
