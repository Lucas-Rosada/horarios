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

  puts "Dados carregados: #{@onibus.inspect}"

  if @horario_inicial != ''
    puts "Horário inicial: #{@horario_inicial}"

    # Calcular o horário final como uma hora após o horário inicial
    horario_final = (Time.parse(@horario_inicial) + 3600).strftime("%H:%M")

    # Filtrando ônibus com horários dentro da faixa selecionada
    @onibus = @onibus.select do |onibus|
      onibus['horario'] >= @horario_inicial && onibus['horario'] <= horario_final
    end

    puts "Ônibus após filtragem: #{@onibus.inspect}"
  end

  erb :index  
end