class PagesController < ApplicationController
  def assistant
    llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

    interventions = current_user.organisation.interventions.where.not(début: nil)

    description_list = []
    interventions.each do |intervention|
      description_list << "#{intervention.description.gsub('[mail] ', '')} #{l(intervention.début.to_date)}"
    end

    #TODO faire un prompt avec un textfield qui boucle sur cette route

    @results = llm.chat(messages: [{role: "user", content: "Génère moi des nouvelles tâches en te basant sur cette liste : #{description_list.join(', ')}"}]).completion
  end
end
