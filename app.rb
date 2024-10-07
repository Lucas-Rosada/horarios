require 'sinatra'
require 'json'

def carregar_dados_onibus
  if File.exist?('dados_onibus.json')
    file = File.read('dados_onibus.json')
    JSON.parse(file)
  else
    []
  end
end

get '/' do
  @horario_inicial = params['horario_inicial'] || ''
  
  @onibus = carregar_dados_onibus

  if @horario_inicial != ''
    horario_final = (Time.parse(@horario_inicial) + 3600).strftime("%H:%M")

    @onibus = @onibus.select do |onibus|
      onibus['horario'] >= @horario_inicial && onibus['horario'] <= horario_final
    end
  end

  erb :index  
end
