//= require ./vendors/react-pivot-standalone-1.18.2.min.js

var dimensions = [
  {value: 'fellow', title: 'Fellow'},
  {value: 'event_name', title: 'Event Name'},
  {value: 'media', title: 'Media'},
  {value: 'topic', title: 'Topic'},
  {value: 'impact_type', title: 'Impact Type'},
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

var genreic_template = function (val, row) {
  var v = val.toFixed(2);
  return v === "0.00" ? "<span class='text-muted'>" +v+ "<span>" : v;
}

var calculations = [
  {
    title: 'Facebook Likes', value: 'fbLikes',
    template: genreic_template
  },
  {
    title: 'Facebook Shares', value: 'fbShares',
    template: genreic_template
  },
  {
    title: 'Facebook Comments', value: 'fbComments',
    template: genreic_template
  },
  {
    title: 'Twitter Mentions', value: 'twMentions',
    template: genreic_template
  },
  {
    title: 'Google Shares', value: 'googleShares',
    template: genreic_template
  }
];