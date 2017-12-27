import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native';
import {
  StackNavigator
} from 'react-navigation';

AppRegistry.registerComponent('DemoProject', () => RootPage);
export default class RootPage extends React.Component {
  render() {
    return <CustomStack />;
  }
}



class HomeVC extends React.Component {
  static navigationOptions = {
    title: 'HomeVC',
  };
  render() {
    const {
      navigate
    } = this.props.navigation;
    return (
      <View>
        <Text>Hello, This is HomeVC!</Text>
        <Button
          onPress={() => navigate('SecondPage')}
          title="Jump to SecondVC"
        />
      </View>
    );
  }
}


class SecondVC extends React.Component {
  static navigationOptions = {
    title: 'SecondVC',
  };
  render() {
    return (
      <View>
        <Text>Now, you are in SecondVC</Text>
      </View>
    );
  }
}

export const CustomStack = StackNavigator({
  HomePage: {
    screen: HomeVC
  },
  SecondPage: {
    screen: SecondVC
  },
});