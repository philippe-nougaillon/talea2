class PagesController < ApplicationController
  def assistant
    llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

    interventions = current_user.organisation.interventions

    infos = []
    interventions.each do |intervention|
      infos << "#{intervention.description} #{l(intervention.début.to_date)}"
    end

    @results = llm.chat(messages: [{role: "user", content: "Génère moi des nouvelles tâches en te basant sur cette liste : #{infos.join(', ')}"}]).completion
  end
end
