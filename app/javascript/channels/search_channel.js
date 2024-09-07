import consumer from 'channels/consumer';
import fetchAnalytics from 'analytics/fetch_analytics';

const searchChannel = (ipAddress) =>
  consumer.subscriptions.create(
    { channel: 'SearchChannel', ip_address: ipAddress },
    {
      connected() {
        // Called when the subscription is ready for use on the server
        console.debug(
          `Connected to SearchChannel subscription for ip address ${ipAddress}`
        );
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.debug(
          `Disconnected from SearchChannel subscription for ip address ${ipAddress}`
        );
      },

      sendSearch(query, sessionId) {
        console.log({ sendSearch: this });
        this.perform('receive', {
          query: query,
          ip_address: ipAddress,
          complete: false,
          session_id: sessionId,
        });
      },

      completeSearch(query, sessionId) {
        console.log({ completeSearch: this });
        this.perform('receive', {
          query: query,
          ip_address: ipAddress,
          complete: true,
          session_id: sessionId,
        });
        setTimeout(() => {
          fetchAnalytics();
        }, 500);
      },
    }
  );

export default searchChannel;
