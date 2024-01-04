server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;

        server_name realmoneycompany.com www.realmoneycompany.com;

        location / {
                try_files $uri /index.html;
        }
}

server {
        server_name blog.realmoneycompany.com;

        location / {
                proxy_pass http://127.0.0.1:5000;
        }
}

server {
        server_name tracker.realmoneycompany.com;

        location / {
                proxy_pass http://127.0.0.1:5002;
        }
}

server {
        server_name dev.realmoneycompany.com;

        location / {
                proxy_pass http://127.0.0.1:5003;
        }
}

server {
       server_name usernamegenerator.realmoneycompany.com;

       location / {
                proxy_pass http://127.0.0.1:5004;
        }
}
