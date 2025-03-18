<?php
define('USE_FULLEMAIL_FOR_LOGIN', true);

// Set your server details
define('AUTODISCOVER_IMAP_SERVER', 'mail.alchemic.it');
define('AUTODISCOVER_IMAP_PORT', 993);
define('AUTODISCOVER_IMAP_SSL', true);

define('AUTODISCOVER_SMTP_SERVER', 'mail.alchemic.it');
define('AUTODISCOVER_SMTP_PORT', 587);
define('AUTODISCOVER_SMTP_SSL', true);

// Enable or disable backends
define('AUTODISCOVER_ENABLE_IMAP', true);
define('AUTODISCOVER_ENABLE_SMTP', true);

// Define your ActiveSync server's URL
define('AUTODISCOVER_ACTIVESYNC_URL', 'https://activesync.alchemic.it/Microsoft-Server-ActiveSync');

// Optional: Configure additional settings or domains if required
define('AUTODISCOVER_DEFAULT_EMAIL_DOMAIN', 'alchemic.it');
