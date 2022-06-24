require 'rails_helper'

RSpec.describe "Robots", type: :request do
    let(:valid_attributes1) { 
        ["PLACE 1,2,EAST", "MOVE", "MOVE", "LEFT", "MOVE", "REPORT"]
    }

    let(:valid_attributes2) { 
        ["PLACE 0,0,NORTH", "LEFT", "REPORT"]
    }

    let(:valid_attributes3) { 
        ["PLACE 0,1,SOUTH", "MOVE", "RIGHT", "MOVE", "LEFT", "LEFT", "REPORT"]
    }

    let(:valid_attributes4) { 
        ["PLACE 1,1,WEST", "MOVE", "RIGHT", "RIGHT", "RIGHT", "REPORT"]
    }

    let(:invalid_attributes) { 
        ["MOVE", "REPORT", "PLACE 5,4,EAST", "MOVE", "MOVE", "LEFT", "MOVE", "REPORT"]
    }

    describe "validating the commands" do
        it "display result for valid command with attribute-1" do
            post "/api/robot/0/orders", params: { Commands: valid_attributes1 }, as: :json
            expect(JSON.parse(response.body)).to eq(
                { 
                    'location' => [3,3,'NORTH']
                }
            ) 
            expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "display result for valid command with attribute-2" do
            post "/api/robot/0/orders", params: { Commands: valid_attributes2 }, as: :json
            expect(JSON.parse(response.body)).to eq(
                { 
                    'location' => [0,0,'WEST']
                }
            ) 
            expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "display result for valid command with attribute-3" do
            post "/api/robot/0/orders", params: { Commands: valid_attributes3 }, as: :json
            expect(JSON.parse(response.body)).to eq(
                { 
                    'location' => [0,0,'EAST']
                }
            ) 
            expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "display result for valid command with attribute-4" do
            post "/api/robot/0/orders", params: { Commands: valid_attributes4 }, as: :json
            expect(JSON.parse(response.body)).to eq(
                { 
                    'location' => [0,1,'SOUTH']
                }
            ) 
            expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "display warning for invalid command" do
            post "/api/robot/0/orders", params: { Commands: invalid_attributes }, as: :json
            expect(JSON.parse(response.body)).to eq(
                { 
                    'warning' => 'Enter valid value for x & y in PLACE command' 
                }
            ) 
            expect(response.content_type).to match(a_string_including("application/json"))
        end
    end
end