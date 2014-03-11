# encoding: UTF-8

module TypeForm
  
  class DataMapper

    def initialize typeform_response, object_template
      @question_mapper = QuestionMapper.new typeform_response["questions"]
      @responses = Responses.new typeform_response["responses"]
      @object_template = object_template
    end

    def map 
      @responses.map do |response|
        map_answers response, @object_template
      end
    end

    private 

    def map_answers answers, template
      template.map do |key, value|
        if value.is_a? Hash
          [ key, map_answers(answers, value) ]
        else 
          field = @question_mapper.find value
          [ key, answers[field] ]
        end
      end.to_h
    end
  end

end