# Search Track

## Overview

Search Track is a web application designed to log, track, and display real-time search query analytics efficiently. Utilizing a modern tech stack, including Ruby on Rails, ActionCable, RSpec, TailwindCSS, and more, Search Track enables users to view top and recent search trends dynamically and interactively.

## Technologies Utilized

- Ruby
- Rails for backend services
- ActionCable for real-time functionality
- RSpec for testing
- TailwindCSS for frontend styling
- PostgreSQL for the database
- `fly` for deployment
- GitHub Actions for CI/CD

## Requirements

Ensure that the following versions are installed:

- **PostgreSQL**: Version 15 and above.
- **Ruby**: Version 3.3.5.
- **Rails**: Version 7.2.1.

Please refer to the specific versions in the `Gemfile.lock` to ensure compatibility during development.

## Local Development Setup

1. **Clone the project:**

```bash
git clone git@github.com:bolah2009/search_track.git
```

2. **Install Dependencies:**

```bash
bundle install
yarn install # for CSS packages, linters, and formatters
```

3. **Setup the Database:**

```bash
bundle exec rails db:setup
# This command creates the database, loads the schema, and initializes it with seed data.
```

4. **Run Migrations:**

```bash
bundle exec rails db:migrate
```

5. **Start the Server:**

```bash
rails server
bin/rails tailwindcss:watch # for Tailwind CSS
```

Alternatively, you can start the server with TailwindCSS using:

```bash
./bin/dev
```

6. **Access the Web App at:** [http://localhost:3000](http://localhost:3000)

## Deployed Version

### Live Link

- [Web App Live Link](https://search-track.fly.dev/)

## Key Features

1. **Real-time Search Query Logging:**

   - Track search queries dynamically as users type.
   - Update search results in real time without refreshing the page.

2. **Query Completion Detection:**

   - Detect search completion based on user interactions (e.g., pause, pressing enter, or losing focus).

3. **Top and Recent Queries Analytics:**
   - View top queries by frequency.
   - View the most recent queries for a given session.

## Search Tracking Specification

- Search records are tracked by:
  - `query`: The text entered by the user.
  - `session_id`: The unique identifier for each user's session.
  - `ip_address`: The IP address from where the query was made.
  - `complete`: Boolean flag indicating if the query is complete.

## Analytics Display

- **Top Queries**: Displays the most frequently searched queries based on user IP.
- **Recent Queries**: Shows the most recent queries made by the user.

## Running Tests

To run automated tests, use:

```bash
rspec --force-color --format documentation
```

To run Rubocop for linting:

```bash
rubocop
```

To automatically fix linting issues:

```bash
rubocop -a
# or
rubocop -A
```

## Future Improvements

- Enhance real-time query analytics with more granular filters.
- Improve the UI for analytics visualization.
- Implement user authentication for personalized search analytics.
- Refactor for better performance and scalability.
- Improve the cache invalidation mechanism for queries.

## 👤 Author

- GitHub: [@bolah2009](https://github.com/bolah2009)
- Twitter: [@bolah2009](https://twitter.com/bolah2009)
- LinkedIn: [@bolah2009](https://www.linkedin.com/in/bolah2009/)

## 📝 License

[MIT licensed](./LICENSE).
