# Nginx Proxy Formula

This formula sets up a simple reverse proxy using Nginx.

## Example/Default Pillar

	nginx_proxy:
		# Use SSL for client/proxy connection?
		ssl: True

		# Redirects incoming connections on this port to HTTPS connection
		# to "from_host" on "from_port"
		# Set to False to disable redirect.
		ssl_redirect: '80'

		# Proxy's upstream port
        to_port: '8080'

		# Downstream port
        from_port: '443'

		# Upstream host
        to_host: '127.0.0.1'

		# Downstream host
        from_host: 'localhost'

		# Location of SSL certs (will be created if they don't exist)
        cert: '/etc/nginx/nginx.crt'
        key: '/etc/nginx/nginx.key'
