# smartwaiver

smartwaiver is a wrapper to access the Smartwaiver API.

- [API docs][api_docs] are available online.
- To use this gem, you will need to login to your Smartwaiver account then go to [apply for an API Key][apply_keys].
- This gem is a port of the [PHP wrapper][php_wrapper].

## Installation
Include the gem in your Gemfile:
``` ruby
gem "smartwaiver", "~> 0.0.5"
```

Create a initializers/smartwaiver.rb file:
``` ruby
Smartwaiver.api_key = "your-key-here"
Smartwaiver.api_version = "v3"
Smartwaiver.webhook_private_key = "your-webhook-private-key-here"
```

That's it!

## Usage
You can use the Smartwaiver module in any controller, for example:

``` ruby
class ApisController < ApplicationController
  def examples

    @api_result = Smartwaiver.get_waivers(10)
    @output = "";

    if @api_result["participants"].blank?
      @output = "No Waivers found." # if you don't have any waivers it'll fail here

    else

      @api_result["participants"]["participant"].each do |participant|

        # the next 2 lines are just examples of how to obtain each participant's information.  For a full list of values please go to: https://www.smartwaiver.com/p/API
        @output << "#{participant['waiver_id']}: #{participant['firstname']} #{participant['lastname']} <br />"
      end
    end
    render :layout => false

  end
end
```

The 3 methods included in this gem are:
``` ruby

# Retrieve up to 10 waivers
@api_result = Smartwaiver.get_waivers(10)

# Retrieve a list of waiver types with their links
@api_result = Smartwaiver.get_waivertypes

# Download a PDF from Smartwaiver
pdf_src = Smartwaiver.download_pdf( participant['pdf_url'] )

```

Look in the examples folder for some sample controllers.


[api_docs]: https://www.smartwaiver.com/p/API
[apply_keys]: https://www.smartwaiver.com/m/rest/
[php_wrapper]: https://github.com/smartwaivercom/smartwaiverapi/tree/master/v3/php
