# Dockerized Node.js Application with PostgreSQL and Nginx

This project demonstrates a multi-container application using Docker and Docker Compose. It includes:

- **Node.js**: Express.js application
- **PostgreSQL**: Database for storing data
- **Nginx**: Web server for handling requests

## Project Structure

```
.
├── app/                    # Node.js application
│   ├── Dockerfile          # Node.js container configuration
│   ├── index.js            # Main application file
│   ├── db.js               # Database connection module
│   ├── package.json        # Node.js dependencies
│   └── .env                # Environment variables
├── db/                     # Database files
│   └── init.sql            # Database initialization script
├── nginx/                  # Nginx configuration
│   ├── Dockerfile          # Nginx container configuration
│   └── nginx.conf          # Nginx server configuration
├── docker-compose.yml      # Docker Compose configuration
└── README.md               # Project documentation
```

## Prerequisites

- Docker
- Docker Compose

## Running the Application

1. Clone the repository:
   ```
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Start the application:
   ```
   docker-compose up -d
   ```

3. Access the application:
   - Open your browser and navigate to `http://localhost`
   - The API is available at:
     - `http://localhost/` - Health check endpoint
     - `http://localhost/db-test` - Database connection test

4. Stop the application:
   ```
   docker-compose down
   ```

## Services

### Node.js Application (Express.js)

- Built with Node.js 18
- Uses Express.js framework
- Connects to PostgreSQL database
- Exposes REST API endpoints

### PostgreSQL Database

- Stores application data
- Initialized with a sample table and data
- Data persists across container restarts

### Nginx Web Server

- Handles incoming HTTP requests
- Proxies requests to the Node.js application
- Configured for production use

## Development

To make changes to the application:

1. Modify the code in the appropriate directories
2. Rebuild and restart the containers:
   ```
   docker-compose down
   docker-compose up -d --build
   ```

## Troubleshooting

- **Database Connection Issues**: Check the PostgreSQL logs with `docker-compose logs db`
- **Application Errors**: Check the Node.js logs with `docker-compose logs web`
- **Nginx Issues**: Check the Nginx logs with `docker-compose logs nginx`
