require 'spec_helper.rb'

module Codebreaker
  RSpec.describe Codebreaker do
    it 'has a version number' do
      expect(Codebreaker::VERSION).not_to be nil
    end

    let(:game) { Game.new }

    describe '#start' do
      it 'calls generate' do
        expect(game).to receive(:generate)
        game.start 1
      end
    end

    describe '#generate' do
      it 'generates values' do
        120.times do
          data = game.generate 4
          expect(data).to match(/[1-6]{4}/)
        end
      end
    end

    describe '#hint' do
      before do
        game.start 5
      end

      it 'makes a hint with 1 digit' do
        game.instance_variable_set('@code', '1234')
        data = game.hint
        expect(data).to eq('1***')
      end

      it 'makes a hint with 2 digits' do
        game.instance_variable_set('@code', '1234')
        game.hint
        data = game.hint
        expect(data).to eq('12**')
      end

      it 'makes a hint with 3 digits' do
        game.instance_variable_set('@code', '1234')
        2.times { game.hint }
        data = game.hint
        expect(data).to eq('123*')
      end

      it 'makes a hint with 4 digits' do
        game.instance_variable_set('@code', '1234')
        3.times { game.hint }
        data = game.hint
        expect(data).to eq('1234')
      end

      it 'makes a hint with 4 digits 5 times' do
        game.instance_variable_set('@code', '1234')
        4.times { game.hint }
        data = game.hint
        expect(data).to eq('1234')
      end
    end

    describe '#guess' do
      before do
        game.start 6
      end

      it 'counts turns' do
        expect{ game.guess '8888' }.to change{ game.turns }.from(6).to(5)
      end

      it 'stops guessing when turns end' do
        6.times { game.guess '8888' }
        data = game.guess '8888'
        expect(data).to be_nil
      end

      it 'guesses a basic number' do
        game.instance_variable_set('@code', '1234')
        data = game.guess '1234'
        expect(data).to eq('++++')
      end

      it 'guesses a basic number in reverse' do
        game.instance_variable_set('@code', '1234')
        data = game.guess '4321'
        expect(data).to eq('----')
      end

      it 'guesses a number with 1 third-party digit' do
        game.instance_variable_set('@code', '1234')
        data = game.guess '1235'
        expect(data).to eq('+++')
      end

      it 'guesses a number with 2 third-party digits' do
        game.instance_variable_set('@code', '1234')
        data = game.guess '1635'
        expect(data).to eq('++')
      end

      it 'guesses a number with 3 third-party digits' do
        game.instance_variable_set('@code', '1264')
        data = game.guess '1375'
        expect(data).to eq('+')
      end

      it 'guesses a number with 4 third-party digits' do
        game.instance_variable_set('@code', '1134')
        data = game.guess '2675'
        expect(data).to eq('')
      end

      it 'guesses a number with 2 third-party digits and 2 digits on wrong places' do
        game.instance_variable_set('@code', '1134')
        data = game.guess '5611'
        expect(data).to eq('--')
      end

      it 'guesses a number with 2 third-party digits and 1 digit on wrong place' do
        game.instance_variable_set('@code', '1134')
        data = game.guess '1561'
        expect(data).to eq('+-')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '3553')
        data = game.guess '5353'
        expect(data).to eq('--++')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '5555')
        data = game.guess '5555'
        expect(data).to eq('++++')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '1233')
        data = game.guess '2133'
        expect(data).to eq('--++')
      end
      
      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '2233')
        data = game.guess '0211'
        expect(data).to eq('+')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '1113')
        data = game.guess '3111'
        expect(data).to eq('-++-')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '1221')
        data = game.guess '2112'
        expect(data).to eq('----')
      end

      it 'guesses a number with duplicate digits' do
        game.instance_variable_set('@code', '1525')
        data = game.guess '2515'
        expect(data).to eq('-+-+')
      end

      it 'guesses a number with duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '2211')
        data = game.guess '2221'
        expect(data).to eq('+++')
      end

      it 'guesses a number with duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '2211')
        data = game.guess '2222'
        expect(data).to eq('++')
      end

      it 'guesses a number with duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '3211')
        data = game.guess '3322'
        expect(data).to eq('+-')
      end

      it 'guesses a number without duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '4221')
        data = game.guess '1111'
        expect(data).to eq('+')
      end

      it 'guesses a number without duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '1221')
        data = game.guess '1111'
        expect(data).to eq('++')
      end

      it 'guesses a number without duplicate digits with duplicates in input' do
        game.instance_variable_set('@code', '4221')
        data = game.guess '2222'
        expect(data).to eq('++')
      end
    end

    describe '#find' do
      before do
        game.instance_variable_set('@length', 4)
        game.instance_variable_set('@matched', Array.new(4) { false })
      end

      it 'finds basic digits' do
        game.instance_variable_set('@code', '1234')
        data = game.find('1')
        expect(data).to be_truthy
      end

      it 'finds basic digits' do
        game.instance_variable_set('@code', '1234')
        data = game.find('2')
        expect(data).to be_truthy
      end

      it 'finds basic digits' do
        game.instance_variable_set('@code', '1234')
        data = game.find('5')
        expect(data).to be_falsey
      end

      it 'finds basic digits continually' do
        game.instance_variable_set('@code', '1234')
        game.find('1')
        game.find('2')
        game.find('4')
        data = game.find('3')
        expect(data).to be_truthy
      end

      it 'finds duplicate digits' do
        game.instance_variable_set('@code', '2234')
        game.find('1')
        game.find('2')
        game.find('4')
        data = game.find('2')
        expect(data).to be_truthy
      end

      it 'finds duplicate digits' do
        game.instance_variable_set('@code', '1234')
        game.find('2')
        data = game.find('2')
        expect(data).to be_falsey
      end

      it 'finds duplicate digits' do
        game.instance_variable_set('@code', '1222')
        game.find('2')
        game.find('2')
        game.find('2')
        data = game.find('2')
        expect(data).to be_falsey
      end

      it 'finds duplicate digits' do
        game.instance_variable_set('@code', '2222')
        game.find('2')
        game.find('2')
        game.find('2')
        data = game.find('2')
        expect(data).to be_truthy
      end

      it 'finds duplicate digits' do
        game.instance_variable_set('@code', '2221')
        game.find('2')
        game.find('2')
        game.find('2')
        data = game.find('1')
        expect(data).to be_truthy
      end
    end
  end
end
