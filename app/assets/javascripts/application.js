// Entry point for the build script in your package.json
require('jquery-ui');
import {} from 'jquery-ujs';
import 'bootstrap/dist/js/bootstrap';

global.bootbox = require('bootbox');

import './src/main';
import './src/file_tree/file_tree_events';
import './src/jquery_plugins/jquery.pickmeup.min';
import './src/apiKeys';
import './src/cloud_server_operation';
import './src/custom_portal';
import './src/delay_run';
import './src/file_tree';
import './src/git';
import './src/projects';
import './src/queue_panel';
import './src/server_booking';
import './src/server_history';
import './src/server_info';
import './src/server_log';
import './src/server_update';
import './src/spec_browsers';
import './src/spec_languages';
import './src/test_list';
import './src/test_lists';
import './src/test_sidebar';
