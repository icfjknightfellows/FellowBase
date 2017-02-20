
var dimensions = [
  {value: 'fellow', title: 'Fellow' , className: 'deminsion'},
  {value: 'project_name', title: 'Project' , className: 'deminsion'},
  {value: 'partner_name', title: 'Partner' , className: 'deminsion'},
  {value: 'event_name', title: 'Event Name' , className: 'deminsion'},
  {value: 'impact_type', title: 'Impact Type' , className: 'deminsion'},
  {value: 'media', title: 'Media' , className: 'deminsion'},
  {value: 'topic', title: 'Topic' , className: 'deminsion'}
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
    case "impact_monitor":
      switch(row.metric_type) {
        case "estimated_views":
          memo.imEstimatedViews = (memo.imEstimatedViews || 0) + parseFloat(row.value);
          break;
        case "regular_score":
          memo.imRegularScore = (memo.imRegularScore || 0) + parseFloat(row.value);
          break;
        case "social_score":
          memo.imSocialScore = (memo.imSocialScore || 0) + parseFloat(row.value);
          break;
      }
      break;
    case "twitter":
      switch(row.metric_type) {
        case "mentions":
          memo.twMentions = (memo.twMentions || 0) + parseFloat(row.value)
          break;
        case "retweets":
          memo.twRetweets = (memo.twRetweets || 0) + parseFloat(row.value)
          break;
        case "sentiment_very_positive":
          memo.twSentimentVeryPositive = (memo.twSentimentVeryPositive || 0) + parseFloat(row.value)
          break;
        case "sentiment_positive":
          memo.twSentimentPositive = (memo.twSentimentPositive || 0) + parseFloat(row.value)
          break;
        case "sentiment_neutral":
          memo.twSentimentNeutral = (memo.twSentimentNeutral || 0) + parseFloat(row.value)
          break
        case "sentiment_negative":
          memo.twSentimentNegative = (memo.twSentimentNegative || 0) + parseFloat(row.value)
          break;
        case "sentiment_very_negative":
          memo.twSentimentVeryNegative = (memo.twSentimentVeryNegative || 0) + parseFloat(row.value)
          break;
        case "sentiment_unknown":
          memo.twSentimentUnknown = (memo.twSentimentUnknown || 0) + parseFloat(row.value)
          break;
      }
      break;
  }
  return memo;
};

var genreic_template = function (val, row) {
  if(val === undefined) {
    return "<span class='text-muted'> — <span>";
  } else {
    var v = val.toFixed(2);
    return v === "0.00" ? "<span class='text-muted'>" +v+ "<span>" : v;

  }
}

var calculations = [
  {
    title: 'FB Likes', value: 'fbLikes',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'FB Shares', value: 'fbShares',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'FB Comments', value: 'fbComments',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Mentions', value: 'twMentions',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Retweets', value: 'twRetweets',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-Very Positive', value: 'twSentimentVeryPositive',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-Positive', value: 'twSentimentPositive',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-Neutral', value: 'twSentimentNeutral',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-Negative', value: 'twSentimentNegative',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-VeryNegative', value: 'twSentimentVeryNegative',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'TW Sentiment-Unknown', value: 'twSentimentUnknown',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'G+ Shares', value: 'googleShares',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'Estimated View', value: 'imEstimatedViews',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'Social Score', value: 'imSocialScore',
    template: genreic_template,
    className: 'matric'
  },
  {
    title: 'Regular Score', value: 'imRegularScore',
    template: genreic_template,
    className: 'matric'
  }
];


var onDimensionChange = function (e) {
  $.ajax({
    url: location.origin + "/user/set_selected_dimensions",
    type:'post',
    data: {
      user_id: user_id,
      selected_dimensions: e.selectedDimensions.join(",")
    },
    success: function(response) {
      if (response.success) {
        console.log("Successfully updated users selected dimensions.");
      } else {
        console.error("Failed updated users selected dimensions.");
      }
    },
    error: function(response) {
      console.error("Failed updated users selected dimensions.");
    }
});
}
