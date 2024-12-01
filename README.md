
# Atom URL

Atom URL is a Rails-based URL shortening service with geolocation and analytics features. This app allows users to shorten long URLs, view basic analytics (such as clicks), and manage their shortened URLs through an intuitive interface. Users must sign up to access features like viewing analytics and deleting their URLs.

## Features

- **URL Shortening**: Users can shorten long URLs for easier sharing.
- **Geolocation**: Fetches geolocation data for a given IP address using an external API (Abstract API).
- **User Authentication**: Utilizes Devise for user authentication, allowing users to access their shortened URLs and analytics.
- **Background Jobs**: Sidekiq handles background tasks, such as processing URL shortening requests.
- **Analytics**: Provides basic analytics (number of clicks, geolocation data, ip-address of visits) for each shortened URL.
- **URL Management**: Users can view, edit, and delete their shortened URLs after signing up.
- **Pagination**: Pagination feature to handle large number of URLs 

## Setup

Follow these steps to set up and run the application locally.

### Prerequisites

Make sure you have the following installed:

- Ruby 3.x (recommended)
- Rails 8.x or higher
- PostgreSQL
- Redis (required for Sidekiq)
- Node.js (for managing JavaScript and assets)

### 1. Clone the Repository

Clone the repository and navigate into the project folder:

```bash
git clone https://github.com/Eddy3129/atom_url.git
cd atom-url
```

### 2. Install Dependencies

Install the necessary Ruby and JavaScript dependencies by running the setup script:

```bash
bin/render-build.sh
```

This script will:
- Install Yarn packages: `yarn install`
- Install Ruby gems: `bundle install`
- Precompile Rails assets: `rails assets:precompile`
- Run database migrations: `rails db:migrate`

### 3. Set Up Environment Variables

Create a `.env` file in the project root directory and add the following environment variables:

```bash
ABSTRACT_API_KEY=your_api_key_here
REDIS_URL=redis://localhost:6379/0
```

You can obtain the API key for Abstract API [here](https://www.abstractapi.com/api/ip-geolocation-api). For Redis, this project uses a free instance from Render, or you can run Redis locally.

Helpful links:
- [Abstract API](https://www.abstractapi.com/api/ip-geolocation-api)
- [Render](https://render.com/)

Optionally, you can use the built in Rails credential feature to store your passkeys.

```bash
bin/rails credentials:edit
```

This will open the encrypted credentials.yml.enc file in your default editor, and any changes you make will be saved back in an encrypted format.

```bash
abstract:
  api_key: your_api_key_here
```

To access the variables, simply do:
```bash
abstract_api_key = Rails.application.credentials.dig(:abstract, :api_key)
```

### 4. Start the Development Server

Once everything is set up, run the Rails server:

```bash
bundle exec rails server
```

Or simply:

```bash
rails server
```

Navigate to `http://localhost:3000` in your browser to access the app.

### 5. Seed Database (Optional)

Optionally, you can seed the database with test data:

```bash
bundle exec rails db:seed
```

### 6. Running Background Jobs (Sidekiq)

If you're using Sidekiq for background processing, start it with the following command:

```bash
bundle exec sidekiq
```

This ensures any background tasks (like URL shortening) are processed.

## Limitations

There are seevral limitations of this project:

### 1. **Lack of Rigorous Security Testing**
   - The app doesn’t currently implement sufficient security measures like input validation, CSRF protection, or SQL injection safeguards, which exposes it to attacks.
   - **Workaround**: Conduct additional security audits and implement protections such as input validation. Leverage Rails' built-in protections against XSS, CSRF, and SQL injection.

### 2. **Malicious URL Creation**
   - Malicious users can shorten harmful URLs that lead to phishing sites or malware downloads, which can put users at risk.
   - **Workaround**: Implement URL validation and content filtering using services like Google Safe Browsing API or PhishTank. Regularly monitor and report harmful URLs, and allow users to flag suspicious links.

### 3. **Rate Limitation of Geolocation API**
   - The Abstract API used for geolocation has rate limits for the free tier. You are restricted to 1 request per second. This makes it less scalable for high-traffic applications.
   - **Workaround**: Upgrade to a paid API plan to increase the rate limit.

### 4. **Performance Issues with Free Tier**
   - The app is currently running on the free tier of Render, which has limited computational resources. This may result in slower performance, especially during high traffic.
   - **Workaround**: For better performance, consider upgrading to a higher-tier plan or using more scalable hosting solutions such as AWS or Heroku for production.

### 5. **Custom Domains**
   - The project currently does not support custom domains for shortened URLs. The URLs are hosted on Render’s default domain.
   - **Workaround**: Configure a DNS service to point to your Render app or set up a redirect mechanism in your app to handle custom domains.

### 6. **Lack of Authentication Features**
   - The authentication system is minimal. It allows users to sign up and log in, but does not include features like email verification, or multi-factor authentication.
   - **Workaround**: Extend the authentication system by integrating additional features such as email confirmation using Devise modules.

### 7. **User Interface (UI) and Experience (UX)**
   - The UI is functional and basic. There's room for improvement in terms of design and user interaction to enhance the user experience.
   - **Workaround**: Implement multiple select feature for users to delete several URLs at once, with smoother animations and loading transitions. Can utilize frameworks like React + Vite or Vue.js for making more dynamic animations. 

### 8. **Load Balancing and Reverse Proxy for Scalability**
   - This solution does not address the scalability and security issues when running on multiple servers. 
   - **Workaround**:  Implement NGINX as a reverse proxy for SSL termination, load balancing, and distribution of resources across multiple servers to handle higher traffic efficiently.
   
