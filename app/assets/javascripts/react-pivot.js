//= require ./vendors/react-pivot-standalone-1.18.2.min.js

var dimensions = [
  {value: 'fellow', title: 'Fellow'},
  {value: 'event_name', title: 'Event Name'},
  {value: 'media', title: 'Media'},
  {value: 'topic', title: 'Topic'},
  {value: 'impact_type_name', title: 'Impact Type'},
  {value: 'partner_name', title: 'Partner'}
];

var reduce = function(row, memo) {
  switch (row.genre) {
    case "facebook":
      switch (row.metric_type) {
        case "likes":
          memo.fbLikes = (memo.fbLikes || 0) + parseFloat(row.value)
          break;
        case "shares":
          memo.fbShares = (memo.fbShares || 0) + parseFloat(row.value)
          break;
        case "comments":
          memo.fbComments = (memo.fbComments || 0) + parseFloat(row.value)
          break;
      }
      break;
    case "google":
      memo.googleShares = (memo.googleShares || 0) + parseFloat(row.value)
      break;
    case "twitter":
      memo.twMentions = (memo.twMentions || 0) + parseFloat(row.value)
      break;
  }
  return memo;
};

var calculations = [
  {
    title: 'Facebook Likes', value: 'fbLikes',
    template: function(val, row) {
      return val.toFixed(2)
    }
  },
  {
    title: 'Facebook Shares', value: 'fbShares',
    template: function(val, row) {
      return val.toFixed(2)
    }
  },
  {
    title: 'Facebook Comments', value: 'fbComments',
    template: function(val, row) {
      return val.toFixed(2)
    }
  },
  {
    title: 'Twitter Mentions', value: 'twMentions',
    template: function(val, row) {
      return val.toFixed(2)
    }
  },
  {
    title: 'Google Shares', value: 'googleShares',
    template: function(val, row) {
      return val.toFixed(2)
    }
  }
];