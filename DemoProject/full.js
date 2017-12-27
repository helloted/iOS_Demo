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
  TabNavigator,
  StackNavigator
} from 'react-navigation';

AppRegistry.registerComponent('DemoProject', () => RootPage);
export default class RootPage extends React.Component {
  render() {
    return <MainTabController />;
  }
}


class HomeVC extends React.Component {
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
    const {
      navigate
    } = this.props.navigation;
    return (
      <View>
        <Text>Hello, This is HomeVC</Text>
        <Button
          onPress={() =>navigate('SecondPage')}
          title="Jump to SecondVC"
        />
      </View>
    );
  }
}

class MessageVC extends React.Component {
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
          This is MessageVC page
        </Text>
      </View>
    );
  }
}


class SettingVC extends React.Component {
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
          This is SettingVC page
        </Text>
      </View>
    );
  }
}

class SecondVC extends React.Component {
  static navigationOptions = {
    title: 'SecondVC',
    tabBarVisible: false
  };
  render() {
    return (
      <View>
        <Text>Now, you are in SecondVC</Text>
      </View>
    );
  }
}

const HomeNav = StackNavigator({
  HomePage: {
    screen: HomeVC,
    navigationOptions: {
      title: 'HomePage',
    }
  },
  SecondPage: {
    screen: SecondVC
  },
});


const MainTabController = TabNavigator({
  TabItem_1: {
    screen: HomeNav
  },
  TabItem_2: {
    screen: MessageVC
  },
  TabItem_3: {
    screen: SettingVC
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