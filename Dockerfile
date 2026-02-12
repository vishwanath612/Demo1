FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY player_car.png /usr/share/nginx/html/player_car.png
COPY enemy_car.png /usr/share/nginx/html/enemy_car.png