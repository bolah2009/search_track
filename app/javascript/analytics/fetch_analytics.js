import updateAnalyticsDisplay from 'analytics/update_analytics_display';

const fetchAnalytics = () => {
  fetch('/analytics')
    .then((response) => response.json())
    .then((data) => {
      console.debug({ data })
      updateAnalyticsDisplay(data);
    })
    .catch((error) => console.error('Error fetching analytics:', error));
};

export default fetchAnalytics;
