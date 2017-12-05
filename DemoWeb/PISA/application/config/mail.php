<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
| -------------------------------------------------------------------
| MAILGUN CONNECTIVITY SETTINGS
| -------------------------------------------------------------------
| This file will contain the settings needed to send email via Mailgun.
|
| For complete instructions please consult the Mailgun documentation
|
*/

$config['mc'] = array(
	'protocol' => 'smtp',
	'smtp_host' => 'ssl://smtp.googlemail.com',
	'smtp_port' => 465,
	'smtp_user' => '',//any mail address
	'smtp_pass' => '',//any words
	'mailtype' => 'html',
	'charset' => 'UTF-8',
	'wordwrap' => TRUE
);

/* End of file mailgun.php */
/* Location: ./application/config/mailgun.php */
