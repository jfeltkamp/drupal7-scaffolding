<?php
/**
 * Created by PhpStorm.
 * User: jfeltkamp
 * Date: 31.07.15
 * Time: 11:39
 */


$databases = array (
    'default' =>
        array (
            'default' =>
                array (
                    'database' => 'jfeltkamp_d7_bbo_2',
                    'username' => 'jfeltkamp',
                    'password' => 'pmaktlefj',
                    'host' => 'RADON',
                    'port' => '',
                    'driver' => 'mysql',
                    'prefix' => '',
                ),
        ),
);

switch ($_SERVER['HTTP_HOST']) {
    case "www.appartements-sankt-englmar.de":
    case "appartements-sankt-englmar.de":
    case "prod.appartements-sankt-englmar.de":
        $env = "LIVE";
        $color = "#ff0000";
        break;
    case "preprod.appartements-sankt-englmar.de":
        $env = "PREPROD";
        $color = "#770099";
        break;
    case "stage.appartements-sankt-englmar.de":
        $env = "STAGE";
        $color = "#770099";
        break;
    default:
        $env = "DEV";
        $color = "#669900";
}


$conf['environment_indicator_overwrite'] = TRUE;
// The text that will be displayed on the indicator.
$conf['environment_indicator_overwritten_name'] = $env;

// Valid css colors for the text and background of the admin toolbar and environment indicator.
$conf['environment_indicator_overwritten_color'] = $color;
$conf['environment_indicator_overwritten_text_color'] = '#ffffff';

// Where your indicator may appear. Allowed values are "top" and "bottom".
$conf['environment_indicator_overwritten_position'] = 'top';