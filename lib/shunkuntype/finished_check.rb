class FinishCheck
  STEPS=[[
          ['frdejuki      1,2,3,4',1,2,3,4],
          ['tgyh        5,6,7,8,9',5,6,7,8,9],
          ['vbc    10,11,12,13,14', 10,11,12,13,14],
          ['mn,    15,16,17,18,19', 15,16,17,18,19],
          ['consol 20,21,22,23,24',20,21,22,23,24],
          ['swx    25,26,27,28,29', 25,26,27,28,29],
          ['lo.    30,31,32,33,34', 30,31,32,33,34],
          ['aqz    35,36,37,38,39', 35,36,37,38,39],
          [';p  40,41,42,43,44,45',40,41,42,43,44,45],
          ['consol 46,47,48,49,50', 46,47,48,49,50]
         ]]
  def initialize
    finish = [[],[]]
    File.open(Shunkuntype::TRAIN_FILE,'r').each{|line|
      name = line.chomp.split(',')[1]
      step = name.scan(/\d+/)[0].to_i
      finish[0] << step
    }

#    text=[['Basic','minute'],['GerardStrong','size']]
    text=[['Basic','minute']]
    1.times{|i|
      print display(STEPS[i],finish[i],text[i][0],text[i][1])
    }
  end

  def display(step,finished,title="***",command="***")
    cont = "You've finished #{title} drills of...\n"
    cont << sprintf("hour | %-21s | step\n",'contents')
    step.each_with_index do |ele,indx|
      cont << sprintf("%4s | %-21s | ",indx,ele[0])
      ele[1..-1].each {|e2|
        cont << e2.to_s+"," if finished.include?(e2)
      }
      cont<< "\n"
    end
    next_step=finished[-1].to_i+1
    cont << "To continue one minute training: shunkuntype -d #{next_step}.\n\n"
    return cont
  end

end
