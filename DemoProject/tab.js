import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  Image,
} from 'react-native';
import {
  TabNavigator
} from 'react-navigation';

AppRegistry.registerComponent('DemoProject', () => RootPage);
export default class RootPage extends React.Component {
  render() {
    return <MainTabController />;
  }
}


class HomeVc extends React.Component {
  static navigationOptions = {
    tabBarLabel: 'Home',
    tabBarIcon: ({
      tintColor
    }) => (
      <Image
        source={require('./imgs/01.png')}
        style={[styles.icon, {tintColor: tintColor}]}
      />
    ),
  };
  render() {
    return (
      <View style={styles.homecontainer}>
        <Text>
          This is HomeVC page
        </Text>
      </View>
    );
  }
}

class SecondVC extends React.Component {
  static navigationOptions = {
    tabBarLabel: 'Message',
    tabBarIcon: ({
      tintColor
    }) => (
      <Image
        source={require('./imgs/02.png')}
        style={[styles.icon, {tintColor: tintColor}]}
      />
    ),
  };
  render() {
    return (
      <View style={styles.secondcontainer}>
        <Text>
          This is SecondVC page
        </Text>
      </View>
    );
  }
}


class ThirdVC extends React.Component {
  static navigationOptions = {
    tabBarLabel: 'Setting',
    tabBarIcon: ({
      tintColor
    }) => (
      <Image
        source={require('./imgs/03.png')}
        style={[styles.icon, {tintColor: tintColor}]}
      />
    ),
  };
  render() {
    return (
      <View style={styles.thirdcontainer}>
        <Text>
          This is ThirdVC page
        </Text>
      </View>
    );
  }
}

const MainTabController = TabNavigator({
  TabItem_1: {
    screen: HomeVc
  },
  TabItem_2: {
    screen: SecondVC
  },
  TabItem_3: {
    screen: ThirdVC
  },
}, {
  tabBarPosition: 'bottom',
  tabBarOptions: {
    activeTintColor: '#e91e63',
  },
});


const styles = StyleSheet.create({
  homecontainer: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center'
  },
  secondcontainer: {
    flex: 1,
    backgroundColor: '#01fcfc',
    alignItems: 'center',
    justifyContent: 'center'
  },
  thirdcontainer: {
    flex: 1,
    backgroundColor: '#65f8ce',
    alignItems: 'center',
    justifyContent: 'center'
  },
  icon: {
    width: 26,
    height: 26,
  },

});