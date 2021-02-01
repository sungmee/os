location /api_tg {
    rewrite  ^/api_tg/?(.*)$ /$1 break;
    proxy_pass https://api.telegram.org/;
}
location /api_hb {
    rewrite  ^/api_hb/?(.*)$ /$1 break;
    add_header Cache-Control no-cache;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_connect_timeout 30s;
    proxy_pass https://api.huobi.pro/;
}