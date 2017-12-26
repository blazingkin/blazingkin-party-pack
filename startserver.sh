. secrets/env.sh
rails assets:precompile
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
rails s -e production -p 3000 -b 0.0.0.0 -d
