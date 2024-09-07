import { Controller } from '@hotwired/stimulus';
import fetchAnalytics from 'analytics/fetch_analytics';

export default class extends Controller {
  connect() {
    // Call the analytics fetch function every 10 seconds
    setInterval(() => {
      fetchAnalytics();
    }, 10000);
  }
}
